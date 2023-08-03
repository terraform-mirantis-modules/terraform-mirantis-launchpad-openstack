##### msr nodes => Istio ingress port ########
resource "openstack_lb_loadbalancer_v2" "lb_msr" {
  name          = "${var.cluster_name}-msr-lb"
  vip_subnet_id = var.internal_subnet_id
}

resource "openstack_lb_listener_v2" "lb_list_msr" {
  protocol        = "TCP"
  name            = "${var.cluster_name}-msr-listener"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb_msr.id
}

resource "openstack_lb_pool_v2" "lb_pool_msr" {
  protocol    = "TCP"
  name        = "${var.cluster_name}-msr-pool"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.lb_list_msr.id
}

resource "openstack_lb_member_v2" "lb_member_msr" {
  count         = var.msr_count
  pool_id       = openstack_lb_pool_v2.lb_pool_msr.id
  protocol_port = 443
  address       = element(openstack_compute_instance_v2.docker-msr.*.network.0.fixed_ip_v4, count.index)
  subnet_id     = var.internal_subnet_id
}

resource "openstack_networking_floatingip_v2" "msr_lb_vip" {
  pool = var.external_network_name
  subnet_id = var.external_subnet_id
}

resource "openstack_networking_floatingip_associate_v2" "msr_vip" {
  floating_ip = openstack_networking_floatingip_v2.msr_lb_vip.address
  port_id     = openstack_lb_loadbalancer_v2.lb_msr.vip_port_id
}

resource "openstack_lb_monitor_v2" "msr" {
  pool_id     = openstack_lb_pool_v2.lb_pool_msr.id
  type        = "TCP"
  delay       = 20
  timeout     = 10
  max_retries = 3
}
