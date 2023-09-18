locals {
  user      = var.amiUserName
  interface = (var.os_name == "CentOS") ? "eth0" : "ens3"
  managers = [
    for ip in module.manager.public_ips : {
      ssh : {
        address = ip
        user    = local.user
        keyPath = local.ssh_key_path
        port    = 22
      }
      role             = "manager"
      privateInterface = local.interface
    }
  ]
  msrs = [
    for ip in module.msr.public_ips : {
      ssh : {
        address = ip
        user    = local.user
        keyPath = local.ssh_key_path
        port    = 22
      }
      role             = "msr"
      privateInterface = local.interface
      mcrConfig : {
        debug : true
        log-opts : {
          max-size : "10m"
          max-file : "3"
        }
        default-address-pools : [
          {
            base : "172.20.0.0/16"
            size : 16
          },
          {
            base : "172.21.0.0/16"
            size : 16
          },
          {
            base : "172.22.0.0/16"
            size : 16
          }
        ]
      }
    }
  ]
  workers = [
    for ip in module.worker.public_ips : {
      ssh : {
        address = ip
        user    = local.user
        keyPath = local.ssh_key_path
        port    = 22
      }
      role             = "worker"
      privateInterface = local.interface
    }
  ]
  win_workers = [
    for ip in module.win_worker.public_ips : {
      winRM : {
        address  = ip
        user     = "Administrator"
        password = var.windows_administrator_password
        useHTTPS = true
        insecure = true
      }
      role             = "worker"
      privateInterface = "Ethernet 2"
    }
  ]
  launchpad_tmpl = {
    apiVersion = "launchpad.mirantis.com/mke/v1.4"
    kind       = try(module.msr.cluster_kind, "mke")
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
      msr = {
        version    = var.msr_version
        imageRepo  = var.image_repo
        replicaIDs = "sequential"
        installFlags : try([
          "--ucp-insecure-tls",
          "--dtr-external-url ${module.msr.lb_ip}",
        ])
      }
      mcr = {
        version           = var.mcr_version
        channel           = "stable"
        installURLLinux   = "https://get.mirantis.com/"
        installURLWindows = "https://get.mirantis.com/install.ps1"
        repoURL           = "https://repos.mirantis.com"
      }
      hosts = concat(local.managers, local.msrs, local.workers, local.win_workers)
    }
  }
  hosts = concat(local.managers, local.msrs, local.workers, local.win_workers)

}

output "mke_cluster" {
  value = yamlencode(local.launchpad_tmpl)
}

output "hosts" {
  value       = concat(local.managers, local.msrs, local.workers, local.win_workers)
  description = "All hosts in the cluster"
}

output "mke_lb" {
  value       = module.manager.lb_ip
  description = "The LB path for the MKE endpoint"
}

output "msr_lb" {
  value       = module.msr.lb_ip
  description = "The LB path for the MSR endpoint"
}

output "cluster_name" {
  value       = local.cluster_name
  description = "The name of the cluster"
}

output "subnet_id" {
  value       = module.vnet.subnet_id
  description = "Internal Openstack subnet ID"
}
