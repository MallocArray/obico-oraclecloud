output "instance_public_ip" {
  value = "${oci_core_instance.obico_instance.public_ip}"
  }

output "tds_public_url" {
  value = "${format("http://%s:3334", oci_core_instance.obico_instance.public_ip)}"
}

output "comments" {
  value = "Obico should become available in aproximately 5-10 minutes, once updates and installation have completed"
}
