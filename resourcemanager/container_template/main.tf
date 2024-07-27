module "oke_vcn" {
  source              = "../modules/oke_vcn"
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  name_prefix         = var.name_prefix
  freeform_tags       = var.freeform_tags
}

module "container" {
  source              = "../modules/container"
  tenancy_ocid     = var.tenancy_ocid
  # compartment_ocid = module.compartment.compartment_id
  compartment_ocid = var.compartment_ocid
  availability_domain = var.availability_domain
  name_prefix         = var.name_prefix
  api_endpoint_public_subnet_ocid = module.oke_vcn.api_endpoint_public_subnet_ocid
  lb_public_subnet_ocid = module.oke_vcn.lb_public_subnet_ocid
  worker_nodes_private_subnet_ocid = module.oke_vcn.worker_nodes_private_subnet_ocid
  vcn_id              = module.oke_vcn.vcn_id
  type = var.type
  cluster_cluster_pod_network_options_cni_type = var.cluster_cluster_pod_network_options_cni_type
  cluster_endpoint_config_is_public_ip_enabled = var.cluster_endpoint_config_is_public_ip_enabled
  is_kubernetes_dashboard_enabled = var.is_kubernetes_dashboard_enabled
  is_tiller_enabled = var.is_tiller_enabled
  node_shape = var.node_shape
  node_pool_node_shape_config_ocpus = var.node_pool_node_shape_config_ocpus
  node_pool_node_shape_config_memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
  node_pool_node_source_details_boot_volume_size_in_gbs = var.node_pool_node_source_details_boot_volume_size_in_gbs
  num_nodes = var.num_nodes
  kubecfg_token_version = var.kubecfg_token_version
}