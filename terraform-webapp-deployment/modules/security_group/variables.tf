# modules/security_group/variables.tf
variable "name" {
  description = "The name of the security group"
  type        = string
}

variable "alb_name" {
  description = "The name of the alb security group"
  type        = string
}

variable "bst_name" {
  description = "The name of the bst security group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be applied"
  type        = string
}
