# Output variables from created vcn

output "api_endpoint_public_subnet_ocid" {
  value = "${oci_core_subnet.api_endpoint_public_subnet.id}"
}

output "lb_public_subnet_ocid" {
  value = "${oci_core_subnet.lb_public_subnet.id}"
}

output "worker_nodes_private_subnet_ocid" {
  value = "${oci_core_subnet.worker_nodes_private_subnet.id}"
}

output "vcn_id" {
  value = "${oci_core_virtual_network.vcn.id}"
}
