resource "openstack_networking_secgroup_v2" "docker-worker" {
  name        = "${var.cluster_name}-worker"
  description = "Worker specific security group"
}

#TODO: check if necessarry (Istio)


