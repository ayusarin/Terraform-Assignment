# modules/subnet/variables.tf
variable "name" {
  description = "The name prefix for the subnets"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones for the subnets"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
  type        = bool
  default     = false
}
