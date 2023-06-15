locals {
  user      = var.amiUserName
  interface = (var.os_name == "CentOS") ? "eth0" : "ens3"
  managers = [
    for ip in module.manager.public_ips : {
      ssh : {
        address = ip
        user    = local.user
        keyPath = var.ssh_key_path
        port    = 22
      }
      role             = "manager"
      privateInterface = local.interface
    }
  ]
  workers = [
    for ip in module.worker.public_ips : {
      ssh : {
        address = ip
        user    = local.user
        keyPath = var.ssh_key_path
        port    = 22
      }
      role             = "worker"
      privateInterface = local.interface
    }
  ]
  launchpad_tmpl = {
    apiVersion = "launchpad.mirantis.com/mke/v1.4"
    kind       = "mke"
    metadata = {
      name = local.cluster_name
    }
    spec = {
      mke = {
        version       = var.mke_version
        imageRepo     = var.image_repo
        adminUsername = local.admin_username
        adminPassword = local.admin_password
        installFlags : try([
          "--san=${module.manager.lb_ip}",
          "--nodeport-range=32768-35535",
          "--default-node-orchestrator=kubernetes",
          "--cloud-provider=external",
        ])
      }
      mcr = {
        version = var.mcr_version
        channel = "stable"
        repoURL = "https://repos.mirantis.com"
      }
      hosts = concat(local.managers, local.workers)
    }
  }
  hosts = concat(local.managers, local.workers)

}

output "mke_cluster" {
  value = yamlencode(local.launchpad_tmpl)
}

output "hosts" {
  value       = concat(local.managers, local.workers)
  description = "All hosts in the cluster"
}

output "mke_ui_endpoint" {
  value       = "https://${module.manager.lb_ip}"
  description = "The LB path for the MKE endpoint"
}
