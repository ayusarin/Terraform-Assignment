output "web_security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.web_sg.id
}

output "alb_security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.alb_sg.id
}

output "bst_security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.bst_sg.id
}