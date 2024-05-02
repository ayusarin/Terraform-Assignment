# modules/load_balancer/variables.tf
variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the load balancer"
  type        = string
}

variable "public_subnets" {
  description = "A list of subnet IDs where the load balancer will be deployed"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Specifies whether deletion protection is enabled for the load balancer"
  type        = bool
  default     = false
}

variable "deletion_protection_enabled" {
  description = "Indicates whether deletion protection is enabled for the load balancer"
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "The port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "vpc_id" {
  description = "The ID of the VPC where the load balancer will be deployed"
  type        = string
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "The port to use when performing health checks on targets"
  type        = number
  default     = 80
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check"
  type        = number
  default     = 10
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = number
  default     = 3
}

variable "listener_port" {
  description = "The port on which the load balancer is listening"
  type        = number
  default     = 80
}
