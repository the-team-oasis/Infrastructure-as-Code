# Variables passed into compartment module
variable "tenancy_ocid" {}
variable "availability_domain" {}
variable "compartment_ocid" {}
variable "vcn_id" {}
variable "api_endpoint_public_subnet_ocid" {}
variable "lb_public_subnet_ocid" {}
variable "worker_nodes_private_subnet_ocid" {}
variable "name_prefix" {}
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