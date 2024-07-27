# Variables passed into vcn module

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "availability_domain" {}
variable "name_prefix" {}
variable "freeform_tags" {}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "api_endpoint_public_subnet_cidr" {
  default     = "10.0.0.0/30"
}

variable "worker_nodes_private_subnet_cidr" {
  default     = "10.0.1.0/24"
}

variable "lb_public_subnet_cidr" {
  default     = "10.0.2.0/24"
}

variable "api_endpoint_port" {
  type        = string
  default     = "6443"
}