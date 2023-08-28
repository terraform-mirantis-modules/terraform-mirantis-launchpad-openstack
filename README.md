# Module used for the creation of OpenStack resources used for installation of Mirantis products such as MKE, MCR.

Mirantis Launchpad CLI tool ("**launchpad**") simplifies and automates deploying [Mirantis Container Runtime](https://docs.mirantis.com/welcome/mcr), [Mirantis Kubernetes Engine](https://docs.mirantis.com/welcome/mke) and [Mirantis Secure Registry](https://docs.mirantis.com/welcome/msr) on public clouds (like AWS or Azure), private clouds (like OpenStack or VMware), virtualization platforms (like VirtualBox, VMware Workstation, Parallels, etc.), or bare metal.

Launchpad can also provide full cluster lifecycle management. Multi-manager, high availability clusters, defined as having sufficient node capacity to move active workloads around while updating, can be upgraded with no downtime.

## Documentation

Launchpad documentation can be browsed on the [Mirantis Documentation site](https://docs.mirantis.com/mke/3.5/launchpad.html).

## Auth
In order to authenticate you'll need to pass the following variables into the module:
```
  var.openstack_region
  var.openstack_user
  var.openstack_password
  var.openstack_tenant_id
  var.openstack_user_domain_name
  var.openstack_auth_url
  var.openstack_tenant_name
```
You can find these easily by login in your OpenStack instance and downloading the RC file which contains all of the auth info.

## Examples

Launchpad reads a YAML configuration file which lists cluster hosts with their connection addresses and product settings. It will then connect to each of the hosts, make the necessary preparations and finally install, upgrade or uninstall the cluster to match the desired state.

An example configuration:

```yaml
apiVersion: launchpad.mirantis.com/mke/v1.4
kind: mke
spec:
  hosts:
    - role: manager
      ssh:
        address: 10.0.0.1
        user: root
    - role: worker
      ssh:
        address: 10.0.0.2
        user: ubuntu
  mke:
    version: 3.5.5
```

Installing a cluster:

```
$ launchpad apply --config launchpad.yaml


                       ..,,,,,..
              .:i1fCG0088@@@@@880GCLt;,               .,,::::::,,...
         ,;tC0@@@@@@@@@@@@@@@@@@@@@@@@@0:,     .,:ii111i;:,,..
      ,;1ttt1;;::::;;itfCG8@@@@@@@@@i @@@@0fi1t111i;,.
     .,.                  .:1L0@@   @8GCft111ii1;
                               :f0CLft1i;i1tL . @8Cti:.               .,:,.
                           .:;i1111i;itC;  @@@@@@@@@@@80GCLftt11ttfLLLf1:.
                    .,:;ii1111i:,.    , G8@@@@@@@@@@@@@@@@@@@@@@@0Lt;,
            ...,,::;;;;::,.               ,;itfLCGGG0GGGCLft1;:.



   ;1:      i1, .1, .11111i:      .1i     :1;     ,1, i11111111: ;i   ;1111;
   G@GC:  1G0@i ;@1 ;@t:::;G0.   .0G8f    L@GC:   i@i :;;;@G;;;, C@ .80i:,:;
   C8 10CGC::@i :@i :@f:;;;CG.  .0G ,@L   f@.iGL, ;@;     @L     L@. tLft1;.
   G8   1;  ;@i ;@i :@L11C@t   ,08fffL@L  L@.  10fi@;    .@L     L@.    .:t@1
   C0       ;@i :@i :@i   ;Gf..0C     ,8L f@.   .f0@;    .8L     L8  fft11fG;
   ..        .   .   ..     ,..,        , ..      ..      ..     ..  .,:::,

   Mirantis Launchpad (c) 2021 Mirantis, Inc.

INFO ==> Running phase: Open Remote Connection
INFO ==> Running phase: Detect host operating systems
INFO [ssh] 10.0.0.2:22: is running Ubuntu 18.04.5 LTS
INFO [ssh] 10.0.0.1:22: is running Ubuntu 18.04.5 LTS
INFO ==> Running phase: Gather Facts
INFO [ssh] 10.0.0.1:22: gathering host facts
INFO [ssh] 10.0.0.2:22: gathering host facts
INFO [ssh] 10.0.0.1:22: internal address: 172.17.0.2
INFO [ssh] 10.0.0.1:22: gathered all facts
INFO [ssh] 10.0.0.2:22: internal address: 172.17.0.3
INFO [ssh] 10.0.0.2:22: gathered all facts
...
...
INFO Cluster is now configured.  You can access your admin UIs at:
INFO MKE cluster admin UI: https://test-mke-cluster.example.com
INFO You can also download the admin client bundle with the following command: launchpad client-config
```

### Mirantis Launchpad Provider + Mirantis OpenStack Module example
```
module "provision" {
  source  = "terraform-mirantis-modules/launchpad-openstack/mirantis"
  version = "0.4.0"

  // auth/config part
  openstack_region           = var.openstack_region
  openstack_user             = var.openstack_user
  openstack_password         = var.openstack_password
  openstack_tenant_id        = var.openstack_tenant_id
  openstack_user_domain_name = var.openstack_user_domain_name
  openstack_auth_url         = var.openstack_auth_url
  openstack_tenant_name      = var.openstack_tenant_name

  cluster_name          = var.cluster_name
  msr_count             = var.msr_count
  manager_count         = var.manager_count
  manager_instance_type = var.manager_instance_type
  worker_count          = var.worker_count
  worker_instance_type  = var.worker_instance_type
  os_name               = var.os_name

  ssh_base_key_path = var.ssh_base_key_path

  external_network_id   = var.external_network_id
  external_network_name = var.external_network_name
}

// launchpad install from provisioned cluster
resource "launchpad_config" "cluster" {
  skip_destroy = true

  metadata {
    name = module.provision.cluster_name
  }
  spec {
    cluster {
      prune = true
    }

    dynamic "host" {
      for_each = module.provision.hosts

      content {
        role = host.value.role

        # If the host map has ssh settings
        dynamic "ssh" {
          for_each = can(host.value.ssh) ? [1] : [] # one loop if there er a value

          content {
            address  = host.value.ssh.address
            user     = host.value.ssh.user
            key_path = host.value.ssh.keyPath
            port     = 22
          }
        }

        # If the host map has ssh settings
        dynamic "winrm" {
          for_each = can(host.value.winRM) ? [1] : [] # one loop if there er a value

          content {
            address   = host.value.winRM.address
            user      = host.value.winRM.user
            password  = host.value.winRM.password
            use_https = host.value.winRM.useHTTPS
            insecure  = host.value.winRM.insecure
            port      = 5985
          }
        }

      }
    }

    # MCR configuration
    mcr {
      channel             = "stable"
      install_url_linux   = "https://get.mirantis.com/"
      install_url_windows = "https://get.mirantis.com/install.ps1"
      repo_url            = "https://repos.mirantis.com"
      version             = var.mcr_version
    } // mcr

    # MKE configuration
    mke {
      admin_password = var.admin_password
      admin_username = "admin"
      image_repo     = "docker.io/mirantis"
      version        = var.mke_version
      install_flags  = ["--san=${module.provision.mke_lb}", "--default-node-orchestrator=kubernetes", "--nodeport-range=32768-35535"]
      upgrade_flags  = ["--force-recent-backup", "--force-minimums"]
    } // mke

    # MSR configuration

    msr {
      image_repo    = "docker.io/mirantis"
      version       = var.msr_version
      replica_ids   = "sequential"
      install_flags = ["--ucp-insecure-tls"]
    } // msr

  } // spec
}
```

## Support, Reporting Issues & Feedback

Please use Github [issues](https://github.com/terraform-mirantis-modules/terraform-mirantis-launchpad-openstack) to report any issues, provide feedback, or request support.
