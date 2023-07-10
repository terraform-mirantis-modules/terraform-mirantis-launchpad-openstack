variable "cluster_name" {}

variable "worker_count" {}

variable "ssh_key" {}

variable "win_worker_image_name" {}

variable "win_worker_instance_type" {}

variable "worker_volume_size" {
  default = 100
}

variable "external_network_name" {}

variable "internal_network_name" {}

variable "internal_subnet_id" {}

variable "base_sec_group_name" {}

variable "windows_administrator_password" {}
