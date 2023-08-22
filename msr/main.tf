resource "openstack_compute_instance_v2" "docker-msr" {
  count = var.msr_count

  name            = "${var.cluster_name}-msr-${count.index}"
  image_name      = var.msr_image_name
  flavor_name     = var.msr_instance_type
  key_pair        = var.ssh_key
  security_groups = [var.base_sec_group_name, openstack_networking_secgroup_v2.docker-msr.name]
  network {
    name = var.internal_network_name
  }

  user_data = <<EOF
yum install -y nfs-utils || apt install -y nfs-common || zypper -n in nfs-client -y
EOF

}

resource "openstack_networking_floatingip_v2" "docker-msr" {
  count = var.msr_count
  pool  = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "docker-msr" {
  count       = var.msr_count
  floating_ip = element(openstack_networking_floatingip_v2.docker-msr.*.address, count.index)
  instance_id = element(openstack_compute_instance_v2.docker-msr.*.id, count.index)
}
