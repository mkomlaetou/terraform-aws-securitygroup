##########################
# SECURITY GROUP VARIABLES
##########################
variable "sg_name" {
  description = "security group name"
  type        = string
}

variable "sg_vpc" {
  description = "security group vpc id"
  type        = string
}

variable "sg_ports" {
  description = "ingress ports open"
  type        = map(tuple([number, number, string, list(string), list(string), bool]))
  #    default = {
  #     "rule_0" = [ 5432, 5432, "tcp", ["0.0.0.0/0", "10.23.0.0/16","10.36.0.0/16"], [], false]
  #     "rule_1" = [ 5432, 5432, "tcp", ["10.14.0.0/16"]]
  #     "rule_2" = [ 5432, 5432, "tcp", ["10.66.0.0/16"]]
  #   } 
}


variable "custom_tags" {
  type    = map(string)
  default = {}
}