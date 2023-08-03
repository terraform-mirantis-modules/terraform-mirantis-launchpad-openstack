variable "cluster_name" {}

variable "manager_count" {}

variable "ssh_key" {}

variable "manager_image_name" {}

variable "manager_instance_type" {}

variable "manager_volume_size" {
  default = 100
}

variable "external_network_name" {}

variable "internal_network_name" {}

variable "internal_subnet_id" {}

variable "external_subnet_id" {}

variable "base_sec_group_name" {}
