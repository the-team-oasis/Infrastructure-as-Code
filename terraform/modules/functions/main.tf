resource "random_id" "random_id" {
  byte_length = 2
}
resource "oci_functions_application" "my_application" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_prefix}-${var.functions["application_display_name"]}-${random_id.random_id.dec}"
  subnet_ids     = [var.public_subnet_ocid]

  #Optional
  # freeform_tags = var.freeform_tags
}

resource "oci_functions_function" "my_function" {
  depends_on = [null_resource.function_Push2OCIR]
  application_id = oci_functions_application.my_application.id
  display_name   = "${var.name_prefix}-${var.functions["function_display_name"]}-${random_id.random_id.dec}"
  image          = "${var.functions["ocir_docker_repository"]}/${var.functions["ocir_namespace"]}/${var.functions["function_image_repo"]}/${var.functions["function_name"]}:${var.functions["function_image_tag"]}"
  memory_in_mbs  = var.functions["function_memory_in_mbs"]

  #Optional
  # config             = local.function_config
  timeout_in_seconds = var.functions["function_timeout_in_seconds"]

  provisioned_concurrency_config {
    #Required
    strategy = var.functions["provisioned_concurrency_strategy"] # CONSTANT|NONE

    #Optional
    count = var.functions["provisioned_concurrency_count"]
  }

  trace_config {
    #Optional
    is_enabled = var.functions["function_trace_enable"]
  }
}

resource "time_sleep" "wait_for_function_to_be_ready" {
  depends_on = [oci_functions_function.my_function]
  create_duration = "10s"
}

resource "oci_functions_invoke_function" "test_invoke_function" {
  depends_on     = [time_sleep.wait_for_function_to_be_ready]

  #Required
  function_id = oci_functions_function.my_function.id

  #Optional
  invoke_function_body = "{'name': 'Dan'}"
  fn_intent = "httprequest"
  fn_invoke_type = "sync"
  base64_encode_content = false
}

resource "null_resource" "Login2OCIR" {
  depends_on = [oci_functions_application.my_application]

  provisioner "local-exec" {
    command = "echo '${var.functions["ocir_user_password"]}' |  docker login ${var.functions["ocir_docker_repository"]} --username ${var.functions["ocir_namespace"]}/${var.functions["ocir_user_name"]} --password-stdin"
  }
}

resource "null_resource" "function_Push2OCIR" {
  depends_on = [null_resource.Login2OCIR, oci_functions_application.my_application]

  provisioner "local-exec" {
    command     = "image=$(docker images | grep ${var.functions["function_name"]} | grep '${var.functions["function_image_tag"]}' | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
    working_dir = "${path.module}/functions/${var.functions["function_name"]}"
  }

  # Build image using local platform
  # provisioner "local-exec" {
  #   command     = "fn build --verbose"
  #   working_dir = "${path.module}/functions/${var.functions["function_name"]}"
  # }

  # Build image using amd64 (For Apple Silicon build environment)
  provisioner "local-exec" {
    command     = "docker buildx build --platform linux/amd64 -t ${var.functions["ocir_docker_repository"]}/${var.functions["ocir_namespace"]}/${var.functions["function_image_repo"]}/${var.functions["function_name"]}:${var.functions["function_image_tag"]} ."
    working_dir = "${path.module}/functions/${var.functions["function_name"]}"
  }

  provisioner "local-exec" {
    command     = "image=$(docker images | grep ${var.functions["function_name"]} | grep '${var.functions["function_image_tag"]}' | awk -F ' ' '{print $3}')"
    working_dir = "${path.module}/functions/${var.functions["function_name"]}"
  }

  provisioner "local-exec" {
    command     = "docker push ${var.functions["ocir_docker_repository"]}/${var.functions["ocir_namespace"]}/${var.functions["function_image_repo"]}/${var.functions["function_name"]}:${var.functions["function_image_tag"]}"
    working_dir = "${path.module}/functions/${var.functions["function_name"]}"
  }
}