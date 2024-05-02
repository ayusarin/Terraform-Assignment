# modules/route53/main.tf
resource "aws_route53_zone" "private" {
  name = var.private_zone_name
  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region

  }
  
}

resource "aws_route53_record" "alb_record" {

  zone_id = aws_route53_zone.private.zone_id
  name    = "alb"
  type    = "A"
   
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}
