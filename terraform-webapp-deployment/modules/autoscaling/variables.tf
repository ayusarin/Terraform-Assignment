# modules/autoscaling/variables.tf
variable "name" {
  description = "asg name"
  type        = string
}

variable "private_subnet_ids" {
  description = "private subnet id list"
  type        = list(string)
}

variable "min_size" {
  description = "min ec2 in asg"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "max ec2 in asg"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "desired asg"
  type        = number
  default     = 1
}

variable "security_group_id" {
  description = "security group id"
  type        = string
}

variable "image_id" {
  description = "ami id"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "key_name" {
  description = "key pair"
  type        = string
}

variable "user_data" {
  description = "user data"
  type        = string
}

variable "root_volume_size" {
  description = "root vol"
  type        = number
  default     = 30
}

variable "log_volume_size" {
  description = "vol size"
  type        = number
  default     = 20
}

variable "alb_tg_arn" {
  description = "alb tg arn"
  type        = string
}

variable "alert_email" {
  description = "alert email for cw"
  type        = string
}