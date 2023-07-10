output "public_ips" {
  value = openstack_networking_floatingip_v2.docker-worker.*.address
}

output "private_ips" {
  value = openstack_compute_instance_v2.docker-worker.*.network.0.fixed_ip_v4
}

output "machines" {
  value = openstack_compute_instance_v2.docker-worker
}
