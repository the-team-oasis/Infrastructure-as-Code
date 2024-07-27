module "vcn" {
 source              = "../modules/vcn"
 tenancy_ocid        = var.tenancy_ocid
 compartment_ocid    = var.compartment_ocid
 availability_domain = var.availability_domain
 name_prefix         = var.name_prefix
 freeform_tags       = var.freeform_tags
}

module "functions" {
  source                           = "../modules/functions"
  compartment_ocid                 = var.compartment_ocid
  # compartment_ocid               = module.compartment.compartment_id
  public_subnet_ocid               = module.vcn.public_subnet_ocid
  name_prefix                      = var.name_prefix
  freeform_tags                    = var.freeform_tags
  application_display_name         = var.application_display_name
  function_display_name            = var.function_display_name
  function_memory_in_mbs           = var.function_memory_in_mbs
  function_timeout_in_seconds      = var.function_timeout_in_seconds
  provisioned_concurrency_strategy = var.provisioned_concurrency_strategy
  provisioned_concurrency_count    = var.provisioned_concurrency_count
  function_trace_enable            = var.function_trace_enable
  ocir_namespace                   = var.ocir_namespace
  ocir_user_name                   = var.ocir_user_name
  ocir_user_password               = var.ocir_user_password
  ocir_docker_repository           = var.ocir_docker_repository
  function_image_name              = var.function_image_name
  function_image_tag               = var.function_image_tag
  function_image_repo              = var.function_image_repo
}