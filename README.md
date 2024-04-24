# Terraform for Launchpad on Openstack

A terraform module for preparing a basic openstack compute cluster for use with Launchpad.

[Launchpad]{https://docs.mirantis.com/mke/3.7/launchpad.html} is a Mirantis tool for installation 
of Mirantis Containers products. The tool can work with any properly prepared accessible cluster,
This module can create a basic simple cluster, and provide the appropriate Launchpad configuration
for use with Launchpad.

## Prerequisites

* An account and credentials for an openstack tenant
* Terraform [installed](https://learn.hashicorp.com/terraform/getting-started/install)

### Authentication

The Terraform `openstack` provider is configured using input variables described below. These 
variables are used to configure the provider. See https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs
for more details.

## Usage

Use the module to create a basic compute cluster with HCL as follows:

```
module "provision" {
  source = "terraform-mirantis-modules/launchpad-openstack/mirantis"

  cluster_name = "my-cluster" 

  master_count = 1
  worker_count = 3
  msr_count    = 1
}
```

Then use the `mke_cluster` output for the launchpad yaml:

```
terraform output -raw mke_cluster > launchpad.yaml
launchpad apply
```

### Openstack Configuration

You can also control a few more details that configure openstack interaction:

1. `openstack_user` user for openstack connection
2. `openstack_password` password for the user
3. `openstack_tenant_id`
4. `openstack_tenant_name`
5. `openstack_auth_url`
6. `openstack_user_domain_name`

### Cluster Components

Cluster composition can be managed using simple input controls for swarm managers, workers, 
MSR replicas. Windows workers also have their own controls matching controls.

```
os_name             = "ubuntu_18.04" // machine os (must be available in your tenant)
manager_count       = 3              // 3 machines will be created
manager_type        = "prod"         // machine node type (must be available in your tenant)
manager_volume_size = 100GB          // machine volume size
```

### Product configuration

While the Terraform module does not run launchpad, it does prepare the Launchpad configuration
file for you. Because of this you can provide inputs that will then get included into the 
Launchpad yaml.

Each product's installation targets can be configured: 

```
mcr_channel  = "stable"
mcr_repo_url = "https://repos.mirantis.com"
mcr_version  = "23.0.3"

mke_image_repo    = "docker.io/mirantis"
mke_install_flags = [ "--nodeport-range=32768-35535" ]
mke_version       = "3.6.3"

msr_image_repo = "docker.io/mirantis"
msr_install_flags = [ "--ucp-insecure-tls" ]
msr_version        = "2.9.11"
msr_replica_config = "sequential"
```

Specifically, the MKE authentication can be set

```
admin_password = "mirantisadmin"
admin_username = "admin"
```

### Windows workers 

This module supports windows workers. You need only specify the node configuration 
and also incluse a windows admin password.
