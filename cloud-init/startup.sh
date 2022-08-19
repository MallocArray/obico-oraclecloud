#! /bin/sh
echo "Installing prerequisite software"
sudo apt update
sudo apt install docker-compose jq zip -y


echo "Cloning The Spaghetti Detective repo"
cd /
git clone -b release https://github.com/TheSpaghettiDetective/obico-server.git


# Attempt to restore a backup if present
bucket=$(curl -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata | jq -c ".bucket" | tr --delete '"')
if [ $bucket ]; then
	echo "Downloading existing database backup"
	cd /obico-server/backend
	sudo wget ${bucket}db.sqlite3
	cd /obico-server
	sudo wget ${bucket}.env

	echo "Creating backup script file"
	echo '#!/bin/bash' | sudo tee /obico-server/obico-backup.sh
	echo 'bucket=$(curl -L http://169.254.169.254/opc/v1/instance/metadata | jq -c ".bucket" | tr --delete '\''"'\'' )' | sudo tee -a /obico-server/obico-backup.sh
	echo curl -T /obico-server/backend/db.sqlite3 \$bucket | sudo tee -a /obico-server/obico-backup.sh
	echo curl -T /obico-server/.env \$bucket | sudo tee -a /obico-server/obico-backup.sh
	sudo chmod u+x /obico-server/obico-backup.sh

	echo "Scheduling weekly backups of database using cron on Sundays at 1:00 am"
	# https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor
	crontab -l | { cat; echo "* 1 * * 0 /obico-server/obico-backup.sh"; } | crontab -
fi


# Dynamic DNS Update
ddns_url=$(curl -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata | jq -c ".ddns_url" | tr --delete '"')
if [ $ddns_url ]
then
	echo "Updating Dynamic DNS"
	curl "$ddns_url"
fi


echo "Build and start Obico"
cd /obico-server && sudo docker-compose up -d


echo "Install all remaining updates and keep current iptables settings"
sudo iptables -A INPUT -p udp --destination-port 20000:24999 -j ACCEPT
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get upgrade -y


echo "Reboot to ensure all updates are applied"
sudo reboot
