variable "resource_group" {
  type = "string"
}

variable "lb_type" {
  type    = "string"
  default = "public"
}

variable "cluster_name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "name_suffix" {
  type = "string"
}

variable "lb_port" {
  type    = "map"
  default = {}
}

variable "lb_probe_interval" {
  type    = "string"
  default = 5
}

variable "lb_probe_unhealthy_threshold" {
  type    = "string"
  default = 2
}
