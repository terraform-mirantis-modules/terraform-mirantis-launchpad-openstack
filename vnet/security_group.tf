resource "openstack_networking_secgroup_v2" "docker-base" {
  name        = "${var.cluster_name}-base"
  description = "Security group that applies for both managers and workers"
}

#TODO: check if necessarry (Istio)
resource "openstack_networking_secgroup_rule_v2" "base-ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}

resource "openstack_networking_secgroup_rule_v2" "base-int-kubelet" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 10250
  port_range_max    = 10250
  protocol          = "tcp"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}


resource "openstack_networking_secgroup_rule_v2" "base-int-tls-auth" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 12376
  port_range_max    = 12376
  protocol          = "tcp"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}


resource "openstack_networking_secgroup_rule_v2" "default_ipv4_encupsulation" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "4"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}

resource "openstack_networking_secgroup_rule_v2" "base-int-gossip" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 7946
  port_range_max    = 7946
  protocol          = "tcp"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}

resource "openstack_networking_secgroup_rule_v2" "base-int-gossip-udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 7946
  port_range_max    = 7946
  protocol          = "udp"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}

resource "openstack_networking_secgroup_rule_v2" "base-int-bgp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 179
  port_range_max    = 179
  protocol          = "tcp"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}

resource "openstack_networking_secgroup_rule_v2" "base-int-ol-net" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 4789
  port_range_max    = 4789
  protocol          = "udp"
  remote_ip_prefix  = openstack_networking_subnet_v2.docker-int-subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.docker-base.id
}

