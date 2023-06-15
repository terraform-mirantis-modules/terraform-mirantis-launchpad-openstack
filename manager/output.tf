output "lb_ip" {
  value = openstack_networking_floatingip_v2.manager_lb_vip.address
}
output "public_ips" {
  value = openstack_compute_floatingip_associate_v2.docker-manager.*.floating_ip
}

output "private_ips" {
  value = openstack_compute_instance_v2.docker-manager.*.network.0.fixed_ip_v4
}

output "machines" {
  value = openstack_compute_instance_v2.docker-manager
}
