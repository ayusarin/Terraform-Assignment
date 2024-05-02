output "route53_alb_private_dns_name" {
  description = "The ID of the private hosted zone"
  value       = aws_route53_record.alb_record.fqdn
}