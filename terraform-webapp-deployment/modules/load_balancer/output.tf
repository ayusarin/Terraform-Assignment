output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.web_lb.dns_name
}

output "load_balancer_target_group_arn" {
  description = "The DNS name of the load balancer"
  value       = aws_lb_target_group.web_target_group.arn
}
