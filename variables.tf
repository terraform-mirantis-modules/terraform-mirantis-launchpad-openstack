variable "cluster_name" {
  type        = string
  default     = ""
  description = "Please Type your name so that You and Cloud admin can identify your resources."
}

variable "mke_version" {
  type        = string
  default     = "3.6.4"
  description = "The MKE version to be used in the output"
}

variable "msr_version" {
  type        = string
  default     = "2.9.9"
  description = "The MSR version to be used in the output"
}

variable "mcr_version" {
  type        = string
  default     = "23.0.3"
  description = "The MCR version to be used in the output"
}

variable "image_repo" {
  type        = string
  default     = "docker.io/mirantis"
  description = "The image repository to be used in the output"
}

variable "dns_ip_list" {
  type        = list(string)
  default     = []
  description = ""
}

variable "ssh_base_key_path" {
  type        = string
  default     = "./ssh_keys"
  description = "The path to the folder of the ssh key"
}

variable "admin_username" {
  type        = string
  default     = "admin"
  description = "The MKE username use in the output"
}

variable "admin_password" {
  type        = string
  default     = "Mirantisadmin"
  description = "The MKE password use in the output"
}

variable "external_network_name" {
  type        = string
  default     = "public"
  description = "The external OpenStack network name"
}

variable "external_network_id" {
  type        = string
  default     = ""
  description = "The external OpenStack network id"
}

variable "external_subnet_id" {
  type        = string
  default     = ""
  description = "The external OpenStack subnet id"
}

variable "manager_count" {
  type        = number
  default     = 1
  description = "The number of manager machines to be created"
}

variable "msr_count" {
  type        = number
  default     = 1
  description = "The number of MSR machines to be created"
}

variable "worker_count" {
  type        = number
  default     = 3
  description = "The number of Linux worker machines to be created"
}

variable "manager_image_name" {
  type        = string
  default     = "ubuntu_18.04"
  description = "The AMI for the manager instances"
}

variable "worker_image_name" {
  type        = string
  default     = "ubuntu_18.04"
  description = "The AMI for the worker instances"
}

variable "manager_instance_type" {
  type        = string
  default     = "kaas.prod"
  description = "The instance type for the Manager nodes"
}

variable "worker_instance_type" {
  type        = string
  default     = "kaas.prod"
  description = "The instance type for the Worker nodes"
}

variable "msr_instance_type" {
  type        = string
  default     = "kaas.prod"
  description = "The instance type for the MSR nodes"
}

variable "manager_volume_size" {
  type        = number
  default     = 100
  description = "The disk volume size for the manager nodes"
}

variable "worker_volume_size" {
  type        = number
  default     = 100
  description = "The disk volume size for the worker nodes"
}

variable "amiUserName" {
  type        = string
  default     = "ubuntu"
  description = "The dfault username for the AMI. Used as output"
}

variable "os_name" {
  type        = string
  default     = "ubuntu_18.04"
  description = "The name of the OS you want to use(check available OS types in th your OpenStack instance)"
}

variable "openstack_user" {
  type        = string
  default     = "admin"
  description = "The username for the OpenStack account to use"
}

variable "openstack_password" {
  type        = string
  default     = ""
  description = "The OpenStack password of the user"
}

variable "openstack_tenant_id" {
  type        = string
  default     = ""
  description = "The ID for the OpenStack tenant to use"
}

variable "openstack_tenant_name" {
  type        = string
  default     = ""
  description = "The OpenStack tenant name"
}

variable "openstack_auth_url" {
  type        = string
  default     = ""
  description = "The OpenStack authentication url"
}

variable "openstack_user_domain_name" {
  type        = string
  default     = ""
  description = "The OpenStack domain name for the user"
}

variable "openstack_region" {
  type        = string
  description = "This is where you have to mention region"
  default     = "RegionOne"
}

variable "win_worker_count" {
  type    = number
  default = 0
}

variable "windows_administrator_password" {
  type    = string
  default = "M1rantis@dmin"
}

variable "win_worker_image_name" {
  type        = string
  description = "The image name for the Windows worker instances"
}

variable "win_worker_instance_type" {
  type        = string
  default     = "kaas.prod"
  description = "The instance type for the Windows Worker nodes"
}
