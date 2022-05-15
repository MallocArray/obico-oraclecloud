
resource "oci_core_network_security_group" "obico_network_security_group" {
    compartment_id = "${oci_identity_compartment.obico_compartment.id}"
    vcn_id         = "${oci_core_vcn.obicoVCN.id}"
    display_name   = "Obico Required Ports"
}

resource "oci_core_network_security_group_security_rule" "obico_network_security_group_security_rule_3334" {
    network_security_group_id = "${oci_core_network_security_group.obico_network_security_group.id}"
    direction = "INGRESS"
    protocol = "6"
    description = "Port 3334 used for Web Browser communication"
    source   = "${var.source_ip}"
    source_type = "CIDR_BLOCK"
    tcp_options {
        destination_port_range {
            max = "3334"
            min = "3334"
        }
    }
}
