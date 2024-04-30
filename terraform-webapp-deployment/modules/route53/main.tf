# modules/route53/main.tf
resource "aws_route53_zone" "private" {
  name                  = var.private_zone_name
  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }
}
