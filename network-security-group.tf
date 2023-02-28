
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

resource "oci_core_network_security_group_security_rule" "obico_network_security_group_security_rule_webrtc" {
    # https://www.obico.io/docs/server-guides/faqs/#why-doesnt-the-premium-streaming-work
    network_security_group_id = "${oci_core_network_security_group.obico_network_security_group.id}"
    direction = "INGRESS"
    protocol = "17"
    description = "Port used for WebRTC protocol"
    source   = "${var.source_ip}"
    source_type = "CIDR_BLOCK"
    udp_options {
        destination_port_range {
            max = "24999"
            min = "20000"
        }
    }
}

resource "oci_core_network_security_group_security_rule" "obico_network_security_group_security_rule_stun" {
    # https://www.obico.io/docs/server-guides/faqs/#why-doesnt-the-premium-streaming-work
    # https://blog.addpipe.com/troubleshooting-webrtc-connection-issues/
    network_security_group_id = "${oci_core_network_security_group.obico_network_security_group.id}"
    direction = "INGRESS"
    protocol = "17"
    description = "Port used for STUN protocol"
    source   = "${var.source_ip}"
    source_type = "CIDR_BLOCK"
    udp_options {
        destination_port_range {
            max = "3478"
            min = "3478"
        }
    }
}

resource "oci_core_network_security_group_security_rule" "obico_network_security_group_security_rule_stun_tls" {
    # https://www.obico.io/docs/server-guides/faqs/#why-doesnt-the-premium-streaming-work
    # https://blog.addpipe.com/troubleshooting-webrtc-connection-issues/
    network_security_group_id = "${oci_core_network_security_group.obico_network_security_group.id}"
    direction = "INGRESS"
    protocol = "17"
    description = "Port used for STUN TLS protocol"
    source   = "${var.source_ip}"
    source_type = "CIDR_BLOCK"
    udp_options {
        destination_port_range {
            max = "5349"
            min = "5349"
        }
    }
}
