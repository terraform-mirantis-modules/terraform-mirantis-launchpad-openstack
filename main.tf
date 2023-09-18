provider "openstack" {
  use_octavia      = "true"
  insecure         = "true"
  region           = var.openstack_region
  user_name        = var.openstack_user
  password         = var.openstack_password
  tenant_id        = var.openstack_tenant_id
  user_domain_name = var.openstack_user_domain_name
  auth_url         = var.openstack_auth_url
  tenant_name      = var.openstack_tenant_name
}

# Creating two random password for MKE username and Password
resource "random_pet" "admin_username" {
  length = 1
}

resource "random_string" "random" {
  length      = 10
  min_upper   = 4
  min_lower   = 5
  min_numeric = 1
  special     = false
}

locals {
  cluster_name   = var.cluster_name == "" ? random_string.random.result : var.cluster_name
  admin_username = var.admin_username == "" ? random_pet.admin_username.id : var.admin_username
  admin_password = var.admin_password == "" ? random_string.random.result : var.admin_password
  ssh_key_path   = "${var.ssh_base_key_path}/${local.cluster_name}.pem"
}

resource "openstack_compute_keypair_v2" "key-pair" {
  name = local.cluster_name
}

resource "local_file" "ssh_key" {
  content         = openstack_compute_keypair_v2.key-pair.private_key
  filename        = local.ssh_key_path
  file_permission = "0600"
}

module "vnet" {
  source                = "./vnet"
  cluster_name          = local.cluster_name
  region                = var.openstack_region
  external_network_id   = var.external_network_id
  external_network_name = var.external_network_name
  dns_ips               = var.dns_ip_list
}

module "manager" {
  source                = "./manager"
  manager_count         = var.manager_count
  cluster_name          = local.cluster_name
  ssh_key               = openstack_compute_keypair_v2.key-pair.name
  manager_image_name    = var.os_name
  manager_instance_type = var.manager_instance_type
  external_network_name = var.external_network_name
  internal_network_name = module.vnet.network_name
  internal_subnet_id    = module.vnet.subnet_id
  external_subnet_id    = var.external_subnet_id
  base_sec_group_name   = module.vnet.base_security_group_name
}

module "worker" {
  source                = "./worker"
  worker_count          = var.worker_count
  cluster_name          = local.cluster_name
  ssh_key               = openstack_compute_keypair_v2.key-pair.name
  worker_image_name     = var.os_name
  worker_instance_type  = var.worker_instance_type
  external_network_name = var.external_network_name
  internal_network_name = module.vnet.network_name
  internal_subnet_id    = module.vnet.subnet_id
  base_sec_group_name   = module.vnet.base_security_group_name
  external_subnet_id    = var.external_subnet_id
}

module "win_worker" {
  source                         = "./win_worker"
  worker_count                   = var.win_worker_count
  cluster_name                   = local.cluster_name
  ssh_key                        = openstack_compute_keypair_v2.key-pair.name
  win_worker_image_name          = var.win_worker_image_name
  win_worker_instance_type       = var.win_worker_instance_type
  external_network_name          = var.external_network_name
  internal_network_name          = module.vnet.network_name
  internal_subnet_id             = module.vnet.subnet_id
  base_sec_group_name            = module.vnet.base_security_group_name
  windows_administrator_password = var.windows_administrator_password
}

module "msr" {
  source                = "./msr"
  msr_count             = var.msr_count
  cluster_name          = local.cluster_name
  ssh_key               = openstack_compute_keypair_v2.key-pair.name
  msr_image_name        = var.os_name
  msr_instance_type     = var.msr_instance_type
  external_network_name = var.external_network_name
  internal_network_name = module.vnet.network_name
  internal_subnet_id    = module.vnet.subnet_id
  external_subnet_id    = var.external_subnet_id
  base_sec_group_name   = module.vnet.base_security_group_name
}
