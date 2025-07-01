## Overview

This module creates an AWS Security Group with customizable ingress rules.

---

## Features

- **Dynamic Ingress Rules:** Ingress rules are dynamically generated based on the `sg_ports` variable input.
- **Egress Rules:** Allows all outbound (egress) traffic by default.
- **Tagging:** Tags are merged with `local.tags` and a `Name` tag for easy identification.
- **Resource Lifecycle:** Resource is created before destroyed to prevent service interruption.
- **Custom Timeout:** Custom timeout for deletion (2 minutes).

---

## Variables

- `sg_name`: Name prefix for the security group.
- `sg_vpc`: VPC ID where the security group will be created.
- `sg_ports`: List of ingress rule definitions, each as a tuple:
  - `[from_port, to_port, protocol, cidr_blocks, security_groups, self]`


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | security group name | `string` | n/a | yes |
| <a name="input_sg_ports"></a> [sg\_ports](#input\_sg\_ports) | ingress ports open | `map(tuple([number, number, string, list(string), list(string), bool]))` | n/a | yes |
| <a name="input_sg_vpc"></a> [sg\_vpc](#input\_sg\_vpc) | security group vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | security group id |


```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = var.custom_tags
  }
}

##########################################
## CREATE SECURITY GROUP
##########################################

module "priv_sv_sg" {
  source   = "mkomlaetou/securitygroup/aws"
  sg_name  = var.priv_sv
  sg_vpc   = data.aws_vpc.vpc-01.id
  sg_ports = var.priv_sv_sg_ports
}

// sg_id output
output "security_group_ids" {
  value = {
    priv_sv_sg_id = module.priv_sv_sg.sg_id
  }
}


// query vpc
data "aws_vpc" "vpc-01" {
  filter {
    name   = "tag:Name"
    values = ["xyz-vpc-01"]
  }
}


variable "priv_sv_sg_ports" {
  description = "ports open on SG"
  default = {
    "internal" = [0, 0, "-1", [], [], true]
    "onprem"   = [0, 0, "-1", ["10.250.250.0/24"], [], false]
    "ssh"      = [22, 22, "tcp", [], ["sg-09e19884f1e157443"], false]
    "open_vpn" = [1194, 1196, "tcp", ["172.20.100.0/24"], [], false]
  }
}

variable "sg_name" {
    description = "security group name"
    default     = "priv_sv"
}

// Custom tags
variable "custom_tags" {
  default = {
    Environment = "lab"
    Purpose     = "aws-training"
  }
}