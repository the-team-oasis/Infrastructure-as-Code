# Create VCN

resource "random_id" "random_id" {
  byte_length = 2
}

resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_prefix}-okevcn-${random_id.random_id.dec}"
  freeform_tags  = var.freeform_tags
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_prefix}-nat-${random_id.random_id.dec}"
  vcn_id         = oci_core_virtual_network.vcn.id
  freeform_tags  = var.freeform_tags
}

# Create internet gateway to allow public internet traffic

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_prefix}-igw-${random_id.random_id.dec}"
  vcn_id         = oci_core_virtual_network.vcn.id
  freeform_tags  = var.freeform_tags
}

# for service gateway
resource "oci_core_service_gateway" "sgw" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-sgw-${random_id.random_id.dec}"

  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }
}

# Create route table to connect vcn to internet gateway
resource "oci_core_route_table" "routetable_kubernetesapiendpoint" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-routetable-KubernetesAPIendpoint-${random_id.random_id.dec}"
  freeform_tags  = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Create route table to connect vcn to internet gateway
resource "oci_core_route_table" "routetable_serviceloadbalancers" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-routetable-serviceloadbalancers-${random_id.random_id.dec}"
  freeform_tags  = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Create route table to connect vcn to nat gateway
resource "oci_core_route_table" "routetable_workernodes" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-routetable-workernodes-${random_id.random_id.dec}"
  freeform_tags  = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }

  # for service gateway
  route_rules {
    destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw.id
  }
}

# Create Public Subnet for Kubernetes API Endpoint in vcn
resource "oci_core_subnet" "api_endpoint_public_subnet" {
  # availability_domain        = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
  cidr_block                 = "10.0.0.0/30"
  display_name               = "${var.name_prefix}-api-endpoint-public-subnet-${random_id.random_id.dec}"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.vcn.id
  dhcp_options_id            = oci_core_virtual_network.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false #public
  route_table_id             = oci_core_route_table.routetable_kubernetesapiendpoint.id
  security_list_ids          = [oci_core_security_list.seclist_kubernetesapiendpoint.id]
  #defined_tags               = local.my_defined_tags
  freeform_tags = var.freeform_tags
}

# Create Private Subnet for Worker Nodes in vcn
resource "oci_core_subnet" "worker_nodes_private_subnet" {
  # availability_domain        = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
  cidr_block                 = "10.0.1.0/24"
  display_name               = "${var.name_prefix}-worker-nodes-private-subnet-${random_id.random_id.dec}"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.vcn.id
  dhcp_options_id            = oci_core_virtual_network.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true #public
  route_table_id             = oci_core_route_table.routetable_workernodes.id
  security_list_ids          = [oci_core_security_list.seclist_workernodes.id]
  #defined_tags               = local.my_defined_tags
  freeform_tags = var.freeform_tags
}

# Create Public Subnet for Service Load Balancers	 in vcn
resource "oci_core_subnet" "lb_public_subnet" {
  # availability_domain        = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
  cidr_block                 = "10.0.2.0/24"
  display_name               = "${var.name_prefix}-lb-public-subnet-${random_id.random_id.dec}"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.vcn.id
  dhcp_options_id            = oci_core_virtual_network.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false #public
  route_table_id             = oci_core_route_table.routetable_serviceloadbalancers.id
  security_list_ids          = [oci_core_security_list.seclist_loadbalancers.id]
  #defined_tags               = local.my_defined_tags
  freeform_tags = var.freeform_tags
}