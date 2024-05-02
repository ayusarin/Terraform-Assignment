# modules/vpc/variables.tf
variable "name" {
  description = "The name tag for the VPC"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_azs" {
  description = "List of availability zones for subnets"
  type        = list(string)
}


variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
}
