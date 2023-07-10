resource "openstack_networking_secgroup_v2" "docker-worker" {
  name        = "${var.cluster_name}-win-worker"
  description = "Open all external TCP ports to windows worker nodes"
}

#TODO: check if necessarry (Istio)
resource "openstack_networking_secgroup_rule_v2" "worker_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 1
  port_range_max    = 65534
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-worker.id
}

# WinRM
resource "openstack_networking_secgroup_rule_v2" "wirm" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 5985
  port_range_max    = 5986
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-worker.id
}
