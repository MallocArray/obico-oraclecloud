resource "oci_core_vcn" "obicoVCN" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${oci_identity_compartment.obico_compartment.id}"
  display_name   = "${var.project_name}-${random_id.obico_id.dec}"
  dns_label      = "${var.project_name}"
  is_ipv6enabled = "false"
}

resource "oci_core_internet_gateway" "obicoIG" {
  compartment_id = "${oci_identity_compartment.obico_compartment.id}"
  display_name   = "${var.project_name}-IG-${random_id.obico_id.dec}"
  vcn_id         = "${oci_core_vcn.obicoVCN.id}"
}

resource "oci_core_route_table" "obicoRT" {
  compartment_id = "${oci_identity_compartment.obico_compartment.id}"
  vcn_id         = "${oci_core_vcn.obicoVCN.id}"
  display_name   = "${var.project_name}-RT-${random_id.obico_id.dec}"
    route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.obicoIG.id}"
    }
}

resource "oci_core_subnet" "obicoSubnet" {
  cidr_block                 = "10.0.100.0/24"
  compartment_id             = "${oci_identity_compartment.obico_compartment.id}"
  vcn_id                     = "${oci_core_vcn.obicoVCN.id}"
  display_name               = "${var.project_name}-${random_id.obico_id.dec}"
  route_table_id             = "${oci_core_route_table.obicoRT.id}"
}
