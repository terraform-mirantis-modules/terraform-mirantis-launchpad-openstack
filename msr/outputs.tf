output "lb_ip" {
  value = openstack_networking_floatingip_v2.msr_lb_vip.address
}

output "public_ips" {
  value = openstack_networking_floatingip_v2.docker-msr.*.address
}

output "private_ips" {
  value = openstack_compute_instance_v2.docker-msr.*.network.0.fixed_ip_v4
}

output "machines" {
  value = openstack_compute_instance_v2.docker-msr
}

output "cluster_kind" {
  value = "mke+msr"
}
