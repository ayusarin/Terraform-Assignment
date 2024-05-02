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

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "alert_email" {
  description = "alert_email"
  type        = string
}


variable "min_size" {
  description = "min ec2 in asg"
  type        = number
}

variable "max_size" {
  description = "max ec2 in asg"
  type        = number
}

variable "desired_capacity" {
  description = "desired asg"
  type        = number
}

variable "alb_name" {
  description = "alb name"
  type        = string
}

variable "asg_name" {
  description = "asg name"
  type        = string
}