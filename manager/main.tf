resource "openstack_compute_instance_v2" "docker-manager" {
  count = var.manager_count

  name            = "${var.cluster_name}-manager-${count.index}"
  image_name      = var.manager_image_name
  flavor_name     = var.manager_instance_type
  key_pair        = var.ssh_key
  security_groups = [var.base_sec_group_name, openstack_networking_secgroup_v2.docker-manager.name]
  network {
    name = var.internal_network_name
  }
  user_data = <<EOF
#!/bin/bash
# Use full qualified private DNS name for the host name.  Kube wants it this way.
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname)
echo $HOSTNAME > /etc/hostname
sed -i "s|\(127\.0\..\.. *\)localhost|\1$HOSTNAME localhost|" /etc/hosts
hostname $HOSTNAME
EOF

}

resource "openstack_networking_floatingip_v2" "docker-manager" {
  count = var.manager_count
  pool  = var.external_network_name
  subnet_id = var.external_subnet_id
}

resource "openstack_compute_floatingip_associate_v2" "docker-manager" {
  count       = var.manager_count
  floating_ip = element(openstack_networking_floatingip_v2.docker-manager.*.address, count.index)
  instance_id = element(openstack_compute_instance_v2.docker-manager.*.id, count.index)
}
