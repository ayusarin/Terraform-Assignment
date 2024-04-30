# modules/route53/variables.tf
variable "private_zone_name" {
  description = "The name of the private hosted zone"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the private hosted zone will be associated"
  type        = string
}

variable "region" {
  description = "The AWS region where the VPC is located"
  type        = string
}
