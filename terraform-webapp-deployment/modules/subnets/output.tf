output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.example_subnet[*].id
}