variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "The ID of the VPC where the security group will be applied"
  type        = string
}

variable "task_def_list" {
  type = map(object({
    test                     = number
    additional_egress_rules  = optional(list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      prefix_list_ids = optional(list(string))
      description     = string
    })))
    additional_ingress_rules = optional(list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      prefix_list_ids = optional(list(string))
      description     = string
    })))
  }))
  
  default = {
    manage = {
      test = 1
      additional_egress_rules = []
      additional_ingress_rules = [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          prefix_list_ids = []
          description = "outbound access"
        }
      ]
    },
    dashboard = {
      test = 2
      additional_egress_rules = []
      additional_ingress_rules = []
    }
  }
}

locals {
  default_rules = [
    {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      cidr_blocks     = [var.vpc_cidr]
      prefix_list_ids = []
      description     = "vpc cidr"
    }
  ]

  default_ingress_rules = []

  default_egress_rules = [
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = []
      prefix_list_ids = ["pl-78a54011"]
      description     = "s3_prefix_list"
    }
  ]

  merged_task_def_list = {
    for task, values in var.task_def_list : task => {
      test                     = values.test
      additional_egress_rules  = concat(local.default_rules, local.default_egress_rules, values.additional_egress_rules)
      additional_ingress_rules = concat(local.default_rules, local.default_ingress_rules, values.additional_ingress_rules)
    }
  }
}

resource "aws_security_group" "this" {
  for_each = local.merged_task_def_list
  name        = each.key
  vpc_id      = var.vpc_id
  description = "Security group for ${each.key}"

  dynamic "ingress" {
    for_each = each.value.additional_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      prefix_list_ids = ingress.value.prefix_list_ids
    }
  }

  dynamic "egress" {
    for_each = each.value.additional_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      prefix_list_ids = egress.value.prefix_list_ids
    }
  }
}

output "merged_task_def_list" {
  value = local.merged_task_def_list
}
