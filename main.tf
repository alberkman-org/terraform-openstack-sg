resource "openstack_networking_secgroup_v2" "this" {
  name        = var.name
  description = var.description

  tags = toset(values(var.tags))
}

resource "openstack_networking_secgroup_rule_v2" "this" {
  for_each = {
    for idx, r in var.rules : idx => r # unique key per rule
  }

  direction         = each.value.direction
  ethertype         = each.value.ethertype
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min
  port_range_max    = each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.this.id
}