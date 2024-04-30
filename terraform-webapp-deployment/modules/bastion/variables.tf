# modules/autoscaling/variables.tf
variable "name" {
  description = "The name of the autoscaling group"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of subnet IDs where the instances will be deployed"
  type        = list(string)
}

variable "security_group_id" {
  description = "A list of subnet IDs where the instances will be deployed"
  type        = string
}

variable "image_id" {
  description = "The ID of the AMI to use for instances launched by the autoscaling group"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for instances launched by the autoscaling group"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for instances launched by the autoscaling group"
  type        = string
}


variable "root_volume_size" {
  description = "The size of the root volume for instances launched by the autoscaling group, in GB"
  type        = number
  default     = 30
}

variable "log_volume_size" {
  description = "The size of the secondary volume for storing log data, in GB"
  type        = number
  default     = 20
}

# You may add more variables as needed for health check settings, termination policies, etc.
