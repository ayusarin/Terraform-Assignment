output "private_hosted_zone_id" {
  description = "The ID of the private hosted zone"
  value       = aws_route53_zone.private.id
}