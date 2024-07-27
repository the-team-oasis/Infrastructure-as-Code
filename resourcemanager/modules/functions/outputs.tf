
# Output variables from created autonomous database
output "oci_functions_application" {
  value = "${data.oci_functions_application.application}"
}

output "function_invoke_result" {
  value = oci_functions_invoke_function.test_invoke_function
}