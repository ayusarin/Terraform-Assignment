# modules/load_balancer/main.tf
resource "aws_lb" "web_lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection
  #deletion_protection_enabled = var.deletion_protection_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "${var.name}-target-group"
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  deregistration_delay = "3"

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
