variable "cluster_name" {}

variable "msr_count" {}

variable "ssh_key" {}

variable "msr_image_name" {}

variable "msr_instance_type" {}

variable "msr_volume_size" {
  default = 100
}

variable "external_network_name" {}

variable "internal_network_name" {}

variable "internal_subnet_id" {}

variable "external_subnet_id" {}

variable "base_sec_group_name" {}
