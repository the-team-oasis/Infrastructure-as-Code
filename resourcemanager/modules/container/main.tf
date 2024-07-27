resource "random_id" "random_id" {
  byte_length = 2
}
resource "oci_containerengine_cluster" "cluster" {
  # Required
  compartment_id     = var.compartment_ocid
  kubernetes_version = element(sort(data.oci_containerengine_cluster_option.cluster_option.kubernetes_versions), (length(data.oci_containerengine_cluster_option.cluster_option.kubernetes_versions) - 1))
  name               = "${var.name_prefix}-cluster-${random_id.random_id.dec}"
  vcn_id             = var.vcn_id
  type = var.type

  # Optional
  cluster_pod_network_options {
      #Required
      cni_type = var.cluster_cluster_pod_network_options_cni_type
  }
  # defined_tags = {"Operations.CostCenter"= "42"}
  # freeform_tags = {"Department"= "Finance"}

  endpoint_config {
      #Optional
      is_public_ip_enabled = var.cluster_endpoint_config_is_public_ip_enabled
      # nsg_ids = var.cluster_endpoint_config_nsg_ids # for Network Security Group
      subnet_id = var.api_endpoint_public_subnet_ocid
  }

  options {
    # Optional
    add_ons {
      #Optional
      is_kubernetes_dashboard_enabled = var.is_kubernetes_dashboard_enabled
      is_tiller_enabled = var.is_tiller_enabled
    }

    # Optional
    # admission_controller_options
    # kubernetes_network_config
    # persistent_volume_config
    # service_lb_config
    
    service_lb_subnet_ids = [var.lb_public_subnet_ocid]
  }
}

resource "oci_containerengine_node_pool" "node_pool" {
  # Required
  cluster_id         = oci_containerengine_cluster.cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = element(sort(data.oci_containerengine_cluster_option.cluster_option.kubernetes_versions), (length(data.oci_containerengine_cluster_option.cluster_option.kubernetes_versions) - 1))
  name               = "${var.name_prefix}-node-${random_id.random_id.dec}"
  
  # Optional
  # defined_tags = {"Operations.CostCenter"= "42"}
  # freeform_tags = {"Department"= "Finance"}

  node_config_details {
    placement_configs {
      availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
      subnet_id           = var.worker_nodes_private_subnet_ocid

      #Optional
      # capacity_reservation_id
      # fault_domains
      # preemptible_node_config
    }
    size = var.num_nodes

    # Optional
    # is_pv_encryption_in_transit_enabled
    # kms_key_id
    # node_eviction_node_pool_settings {
        #Optional
    #     eviction_grace_duration = "PT60M" # Default PT60M
    #     is_force_delete_after_grace_duration = false # Default false
    # }
  }

  node_shape      = var.node_shape
  node_shape_config {
      #Optional
      memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
      ocpus = var.node_pool_node_shape_config_ocpus
  }

  node_source_details {
      #Required
      image_id = data.oci_core_images.node_images.images[0].id
      source_type = "IMAGE"

      #Optional
      boot_volume_size_in_gbs = var.node_pool_node_source_details_boot_volume_size_in_gbs
  }

  node_metadata = { user_data: base64encode(data.local_file.cloud_init.content) }

  # node_pool_cycling_details {
      #Optional
  #     is_node_cycling_enabled = 
  #     maximum_surge = 
  #     maximum_unavailable = 
  # }

  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEL4LczDkkl8hYGEnrIdM6DfxjcxnsKIWKo14OB6D+hBxVnmI3baHWfAIB1ffQP7Mc32ho1fpOuN+rr3ZqsfN0kSRHniMEo+iuoZ1J0Vd05pVqFYk+swXGYeOe5jdijACRh2dNb4X/ka7n83CUyNSpjAIIa6tEKSd8jNP/03MmPsJKhsUD63AdJCAm1jphj7MLTGROLpbyh8W2kuFNzyRoD+/0IqGnfB0zYZTWvRDniyywL4kipXONejdt1yxT3YsT+FOKmRu4//4+WvuZ1K4B46lR/M4uIdXqZ0R3MhA2r0I0JB7Bt64vLFlGSrVlBfUXijLiI51sQs6Onr/Xlbsl ssh-key-2023-10-10"
}