variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "The ID of the VPC where the security group will be applied"
  type        = string
}

variable "additional_ingress_rules" {
  description = "Ingress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks    = optional(list(string), [])
    prefix_list_ids = optional(list(string), [])
  }))
  default = []
}

variable "additional_egress_rules" {
  description = "Additional egress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks    = optional(list(string), [])
    prefix_list_ids = optional(list(string), [])
  }))
  default = []
}

locals {
  #Add ingress and egress Rules
  default_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
      prefix_list_ids = []
    }
  ]

  #Add only ingress Rules
  default_ingress_rules = [
    
  ]

  ingress_rules = concat(local.default_rules, local.default_ingress_rules, var.additional_ingress_rules)

  #Add only egress Rule
  default_egress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = []
      prefix_list_ids = ["pl-78a54011"]
      description = "s3_prefix_list"
    }
  ]

  egress_rules = concat(local.default_rules, local.default_egress_rules, var.additional_egress_rules)

}

resource "aws_security_group" "this" {
  name        = var.name
  vpc_id      = var.vpc_id
  description = "Security group for ${var.name}"

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      prefix_list_ids = ingress.value.prefix_list_ids
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      prefix_list_ids = egress.value.prefix_list_ids
    }
  }
}

output "security_group_id" {
  value = aws_security_group.this.id
}
