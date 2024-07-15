variable "region" {
  description = "aws regioon"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "vpc_subnet_azs" {
  description = "region az"
  type        = list(string)
}

variable "vpc_private_subnet_cidr" {
  description = "private subnet"
  type        = list(string)
}

variable "vpc_public_subnet_cidr" {
  description = "public subnet"
  type        = list(string)
}

variable "sg_list" {
  description = "List of security groups with their respective rules"
  type = map(object({
    additional_ingress_rules = list(object({
      from_port      = number
      to_port        = number
      protocol       = string
      cidr_blocks    = list(string)
      prefix_list_ids = list(string)
    })),
    additional_egress_rules = list(object({
      from_port      = number
      to_port        = number
      protocol       = string
      cidr_blocks    = list(string)
      prefix_list_ids = list(string)
    }))
  }))
  default = {
    "service1-sg" = {
      additional_ingress_rules = []
      additional_egress_rules = []
    },
    "service2-sg" = {
      additional_ingress_rules = []
      additional_egress_rules = []
    },
    "service3-sg" = {
      additional_ingress_rules = []
      additional_egress_rules = []
    }
  }
}
