variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "availability_domain" {
  default = 1
}
variable "region" {}

provider "oci" {
  region           = "${var.region}"
}