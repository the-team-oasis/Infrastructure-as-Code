data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
data "oci_containerengine_cluster_kube_config" "cluster_kube_config" {
  #Required
  cluster_id = "${oci_containerengine_cluster.cluster.id}"

  #Optional
  token_version = var.kubecfg_token_version
}

data "oci_containerengine_clusters" "clusters" {
  #Required
  compartment_id = "${var.compartment_ocid}"

  filter {
    name   = "id"
    values = ["${oci_containerengine_cluster.cluster.id}"]
  }
}

data "oci_containerengine_cluster_option" "cluster_option" {
  #Required
  cluster_option_id = "all"
}

data "oci_core_images" "node_images" {
    #Required
    compartment_id = "${var.compartment_ocid}"

    #Optional
    operating_system = "Oracle Linux"
    operating_system_version = "8"
    # state = "AVAILABLE"
    # shape = var.cluster_node_shape
    # sort_by = var.image_sort_by
    # sort_order = var.image_sort_order

    filter {
      name   = "display_name"
      values = ["Oracle-Linux-8.9-2024.05.29-0"]
    }

    filter {
      name   = "state"
      values = ["AVAILABLE"]
    }
}

data "local_file" "cloud_init" {
  filename = "${path.module}/cloud-init-scripts/cloud-init.yaml"
}