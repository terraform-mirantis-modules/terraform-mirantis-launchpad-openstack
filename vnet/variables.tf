variable "cluster_name" {}

variable "region" {}

variable "external_network_id" {}

variable "external_network_name" {}

variable "cidr" {
  default = "10.0.0.0/24"
}

variable "dns_ips" {
  type = list(string)
}
