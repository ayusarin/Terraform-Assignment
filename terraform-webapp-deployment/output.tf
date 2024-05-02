output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.load_balancer.load_balancer_dns_name
}

output "route53_alb_private_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.route53.route53_alb_private_dns_name
}