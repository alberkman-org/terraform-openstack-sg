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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}