variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "rules" {
  description = "List of ingress rules to create"
  type = list(object({
    protocol         = string # e.g. "tcp", "udp", "icmp"
    port_range_min   = number # lower port (use 0 for all)
    port_range_max   = number # upper port (same as min for single port)
    remote_ip_prefix = string # CIDR block, e.g. 0.0.0.0/0
    ethertype        = optional(string, "IPv4")
    direction        = optional(string, "ingress")
  }))
}

resource "openstack_networking_secgroup_v2" "this" {
  name        = var.name
  description = var.description
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