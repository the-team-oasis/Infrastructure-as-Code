# Security List Rules for Public Kubernetes API Endpoint Subnet
resource "oci_core_security_list" "seclist_kubernetesapiendpoint" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-seclist-KubernetesAPIendpoint-${random_id.random_id.dec}"
  freeform_tags  = var.freeform_tags

  ingress_security_rules {
    protocol    = "6"
    source      = var.worker_nodes_private_subnet_cidr
    description = "Kubernetes worker to Kubernetes API endpoint communication."
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "External access to Kubernetes API endpoint."
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.worker_nodes_private_subnet_cidr
    description = "Kubernetes worker to control plane communication."
    tcp_options {
      max = "12250"
      min = "12250"
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = var.worker_nodes_private_subnet_cidr
    description = "Path Discovery."
    icmp_options {
      type = "3"
      code = "4"
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    description      = "Allow Kubernetes control plane to communicate with OKE."
  }

  egress_security_rules {
    protocol         = "1"
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    description      = "Path Discovery."
    icmp_options {
      type = "3"
      code = "4"
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.worker_nodes_private_subnet_cidr
    stateless   = false
    description = "Allow Kubernetes control plane to communicate with worker nodes."
  }

  egress_security_rules {
    protocol    = "1"
    destination = var.worker_nodes_private_subnet_cidr
    stateless   = false
    description = "Path Discovery."
    icmp_options {
      type = "3"
      code = "4"
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "TCP traffic for ports: All"
  }
}

# Security List Rules for Private Worker Nodes Subnet
resource "oci_core_security_list" "seclist_workernodes" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_prefix}-seclist-workernodes-${random_id.random_id.dec}"
  vcn_id         = oci_core_virtual_network.vcn.id
  freeform_tags  = var.freeform_tags

  ingress_security_rules {
    protocol    = "all"
    source      = var.worker_nodes_private_subnet_cidr
    description = "Allow pods on one worker node to communicate with pods on other worker nodes."
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.api_endpoint_public_subnet_cidr
    description = "Allow Kubernetes control plane to communicate with worker nodes."
  }

  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    description = "Path Discovery."
    icmp_options {
      type = "3"
      code = "4"
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.lb_public_subnet_cidr
    description = "Load balancer to worker nodes node ports."
    tcp_options {
      min = "30000"
      max = "32767"
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.lb_public_subnet_cidr
    description = "Load balancer to worker nodes node ports."
    tcp_options {
      max = "10256"
      min = "10256"
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = var.worker_nodes_private_subnet_cidr
    description = "Allow pods on one worker node to communicate with pods on other worker nodes."
  }

  egress_security_rules {
    protocol    = "1"
    destination = "0.0.0.0/0"
    stateless   = false
    description = "Path Discovery."
    icmp_options {
      type = "3"
      code = "4"
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    description      = "Allow worker nodes to communicate with OKE."
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.api_endpoint_public_subnet_cidr
    description = "Kubernetes worker to Kubernetes API endpoint communication."
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.api_endpoint_public_subnet_cidr
    description = "Kubernetes worker to Kubernetes API endpoint communication."
    tcp_options {
      max = "12250"
      min = "12250"
    }
  }
}

# Security List Rules for Public Load Balancer Subnet
resource "oci_core_security_list" "seclist_loadbalancers" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-seclist-loadbalancers-${random_id.random_id.dec}"
  freeform_tags  = var.freeform_tags

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Load balancer listener protocol and port. Customize as required."
    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Load balancer listener protocol and port. Customize as required."
    tcp_options {
      max = "80"
      min = "80"
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.worker_nodes_private_subnet_cidr
    description = "Load balancer to worker nodes node ports."
    tcp_options {
      min = "30000"
      max = "32767"
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.worker_nodes_private_subnet_cidr
    description = "Allow load balancer to communicate with kube-proxy on worker nodes."
    tcp_options {
      max = "10256"
      min = "10256"
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "TCP traffic for ports: All"
  }
}