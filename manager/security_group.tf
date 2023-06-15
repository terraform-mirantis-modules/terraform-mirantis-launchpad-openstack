resource "openstack_networking_secgroup_v2" "docker-manager" {
  name        = "${var.cluster_name}-manager"
  description = "Open ingress ports to manager nodes"
}

resource "openstack_networking_secgroup_rule_v2" "manager_ldap" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 389
  port_range_max    = 389
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager_interlock" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 8080
  port_range_max    = 8080
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 443
  port_range_max    = 443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager_https_k8s" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 6443
  port_range_max    = 6443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
