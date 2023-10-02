resource "openstack_networking_secgroup_v2" "docker-manager" {
  name        = "${var.cluster_name}-manager"
  description = "Open ingress ports to manager nodes"
}

resource "openstack_networking_secgroup_rule_v2" "manager-ldap" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 389
  port_range_max    = 389
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-interlock" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 8080
  port_range_max    = 8080
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 443
  port_range_max    = 443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-https-k8s" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 6443
  port_range_max    = 6443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-swarm-manager" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 2376
  port_range_max    = 2376
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-swarm-comm" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 2377
  port_range_max    = 2377
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-etcd-control" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12379
  port_range_max    = 12379
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-etcd-peer" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12380
  port_range_max    = 12380
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-mke-cluster-ca" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12381
  port_range_max    = 12381
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-mke-client-ca" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12382
  port_range_max    = 12382
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-auth-storage" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12383
  port_range_max    = 12383
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-auth-storage-rep" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12384
  port_range_max    = 12384
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-auth-api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12385
  port_range_max    = 12385
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-auth-worker" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12386
  port_range_max    = 12386
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-prom" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12387
  port_range_max    = 12387
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
resource "openstack_networking_secgroup_rule_v2" "manager-int-kube-api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12388
  port_range_max    = 12388
  protocol          = "tcp"
  remote_ip_prefix  = var.internal_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.docker-manager.id
}
