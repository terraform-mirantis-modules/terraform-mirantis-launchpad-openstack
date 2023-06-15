terraform {
  required_version = ">= 1.4.5"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.2"
    }
  }
}
