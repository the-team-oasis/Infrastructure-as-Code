variable "name_prefix" {}
variable "freeform_tags" {
  type = map(string)

  default = {
    freeform_tags = "Freeform Tags"
  }
}

# Variables passed into compartment module
variable "public_subnet_ocid" {
    default = ""
}
variable "application_display_name" {}
variable "function_display_name" {}
variable "function_memory_in_mbs" {}
variable "function_timeout_in_seconds" {}
variable "provisioned_concurrency_strategy" {
  default = "NONE"
}
variable "provisioned_concurrency_count" {
  default = 0
}
variable "function_trace_enable" {}
variable "ocir_namespace" {}
variable "ocir_user_name" {}
variable "ocir_user_password" {}
variable "ocir_docker_repository" {}
variable "function_image_name" {}
variable "function_image_tag" {}
variable "function_image_repo" {}