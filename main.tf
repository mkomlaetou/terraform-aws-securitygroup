
#############################################
# Resource: aws_security_group.sg
#
# This resource creates an AWS Security Group with customizable ingress rules.
#
# Variables:
# - var.sg_name: Name prefix for the security group.
# - var.sg_vpc: VPC ID where the security group will be created.
# - var.sg_ports: List of ingress rule definitions, each as a tuple:
#     [from_port, to_port, protocol, cidr_blocks, security_groups, self]
#
# Features:
# - Dynamic ingress rules based on var.sg_ports input.
# - Allows all outbound (egress) traffic by default.
# - Tags are merged with local.tags and a Name tag.
# - Resource is created before destroyed to prevent service interruption.
# - Custom timeout for deletion (2 minutes).
#############################################
#######################
# CREATE SECURITY GROUP
#######################

resource "random_id" "sg_suffix" {
  byte_length = 2
}


resource "aws_security_group" "sg" {
  name        = "${var.sg_name}-sg-${random_id.sg_suffix.hex}"
  description = "Security Group"
  vpc_id      = var.sg_vpc

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port       = ingress.value[0]
      to_port         = ingress.value[1]
      protocol        = ingress.value[2]
      cidr_blocks     = ingress.value[3]
      security_groups = ingress.value[4]
      self            = ingress.value[5]
      description     = ingress.key
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "all_outbound"
  }

  tags = merge(local.tags, tomap({ "Name" : "${var.sg_name}-sg-${random_id.sg_suffix.hex}" }))

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }
}



