# Variables Exported from env.sh

# Uses Default Value
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "home_region" {}
variable "ssh_public_key" {}
variable "availability_domain" {
  default = 1
}
variable "name_prefix" {}

variable "freeform_tags" {
  type = map(string)

  default = {
    freeform_tags = "Freeform Tags"
  }
}
variable "defined_tags" {
  type = map(string)

  default = {
    "KRSET02.ET" = "ET_TEAM:donghu.kim@oracle.com"
  }
}

# for compute module
variable "compute" {
  type = map(string)

  default = {
    num_nodes      = 1
    instance_shape = "VM.Standard.E4.Flex"
  }
}

# for vm database module
# variable "dbsystem" {
#   type = "map"

#   default = {
#     "database_edition" = "ENTERPRISE_EDITION"
#     "db_version"       = "12.2.0.1"
#     "admin_password"   = "WelCome123##"
#     "character_set"    = "AL32UTF8"
#     "ncharacter_set"   = "AL16UTF16"
#     "db_workload"      = "OLTP"
#     "licence_model"    = "LICENSE_INCLUDED"
#     "node_count"       = 1
#     "shape"            = "VM.Standard2.1"
#     "source"           = "NONE"
#     "time_zone"        = "Asia/Seoul"
#   }
# }

# for container module
variable "container" {
  type = map(string)

  default = {
    "type" = "BASIC_CLUSTER" # BASIC_CLUSTER, ENHANCED_CLUSTER
    "kubernetes_version"              = "LATEST"
    "cluster_cluster_pod_network_options_cni_type" = "FLANNEL_OVERLAY" # FLANNEL_OVERLAY, OCI_VCN_IP_NATIVE
    "cluster_endpoint_config_is_public_ip_enabled" = true
    "is_kubernetes_dashboard_enabled" = false
    "is_tiller_enabled"               = false
    "node_shape"                      = "VM.Standard.E4.Flex"
    "node_pool_node_shape_config_memory_in_gbs" = 16
    "node_pool_node_shape_config_ocpus" = 1
    "node_pool_node_source_details_boot_volume_size_in_gbs" = 50
    "num_nodes"                       = 1
    "kubecfg_token_version"           = "2.0.0"
  }
}

# for functions module
variable "functions" {
  type = map(string)

  default = {
    "function_display_name"            = "hello-nodejs"
    "function_memory_in_mbs"           = 128
    "function_timeout_in_seconds"      = 120
    "provisioned_concurrency_strategy" = "NONE"
    "provisioned_concurrency_count"    = 0
    "function_trace_enable"            = false
    "ocir_namespace"                   = "axlpeslmb1ng"
    "ocir_user_name"                   = "donghu.kim@oracle.com"
    "ocir_user_password"               = "LXwtE9D[GT[#>shnvxi["
    "ocir_docker_repository"           = "icn.ocir.io"
    "function_name"                    = "hello-nodejs"
    "function_image_tag"               = "0.0.1"
    "function_image_repo"              = "my-functions-repo"
  }
}

# for autonomous database module
# variable "adb" {
#   type = "map"

#   default = {
#     "cpu_core_count"                                 = 1
#     "data_storage_size_in_tbs"                       = 1
#     "db_workload"                                    = "DW" #DW (ADW), OLTP (ATP)
#     "is_auto_scaling_enabled"                        = false
#     "is_dedicated"                                   = false
#     "is_preview_version_with_service_terms_accepted" = false
#   }
# }
