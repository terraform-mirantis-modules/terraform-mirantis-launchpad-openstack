resource "openstack_networking_secgroup_v2" "docker-msr" {
  name        = "${var.cluster_name}-msr"
  description = "Open all external TCP ports to msr nodes"
}

#TODO: check if necessarry (Istio)
resource "openstack_networking_secgroup_rule_v2" "msr_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 1
  port_range_max    = 65534
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-msr.id
}
