# Variables passed into compartment module
variable "name_prefix" {}
variable "freeform_tags" {
  type = map(string)

  default = {
    freeform_tags = "Freeform Tags"
  }
}
variable "vcn_id" {
    default = ""
}
variable "type" {}
variable "cluster_cluster_pod_network_options_cni_type" {}
variable "cluster_endpoint_config_is_public_ip_enabled" {}
variable "is_kubernetes_dashboard_enabled" {}
variable "is_tiller_enabled" {}
variable "node_shape" {}
variable "node_pool_node_shape_config_memory_in_gbs" {}
variable "node_pool_node_shape_config_ocpus" {}
variable "node_pool_node_source_details_boot_volume_size_in_gbs" {}
variable "num_nodes" {}
variable "kubecfg_token_version" {}