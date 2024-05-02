# modules/autoscaling/variables.tf
variable "name" {
  description = "bst name"
  type        = string
}

variable "public_subnet_ids" {
  description = "public subnet ids"
  type        = list(string)
}

variable "security_group_id" {
  description = "security group id"
  type        = string
}

variable "image_id" {
  description = "ami"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "key_name" {
  description = "key name"
  type        = string
}


variable "root_volume_size" {
  description = "root vol"
  type        = number
  default     = 30
}

variable "log_volume_size" {
  description = "secondary vol"
  type        = number
  default     = 20
}

