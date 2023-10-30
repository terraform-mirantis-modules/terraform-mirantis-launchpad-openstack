resource "openstack_networking_secgroup_v2" "docker-msr" {
  count         = var.msr_enabled
  name        = "${var.cluster_name}-msr"
  description = "MSR specific security groups"
}

#TODO: check if necessarry (Istio)
resource "openstack_networking_secgroup_rule_v2" "msr-http" {
  count         = var.msr_enabled
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-msr[0].id
}
resource "openstack_networking_secgroup_rule_v2" "msr-https" {
  count         = var.msr_enabled
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 443
  port_range_max    = 443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-msr[0].id
}
