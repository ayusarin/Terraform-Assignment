# modules/autoscaling/main.tf

resource "aws_launch_template" "web_launch_template" {
  name_prefix   = var.name
  image_id      = data.aws_ami.latest.id #var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data
  vpc_security_group_ids  = [var.security_group_id]
  #ebs_optimized = true

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.root_volume_size
      volume_type = "gp3"
      encrypted = true
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = var.log_volume_size
      volume_type = "gp3"
      encrypted = true
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {

  name                = var.name
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  health_check_type                 = "ELB"
  health_check_grace_period         = 30
  wait_for_capacity_timeout         = "10m"
  termination_policies              = ["Default"]

}

# Attach Auto Scaling Group instances to Target Group
resource "aws_autoscaling_attachment" "example_asg_attachment" {

  depends_on = [ 
    aws_autoscaling_group.web_asg,
    aws_launch_template.web_launch_template 
    ]

  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  lb_target_group_arn = var.alb_tg_arn
  
}

# Create Autoscaling Policy
resource "aws_autoscaling_policy" "example_cpu_scale_out_policy" {

  name                   = "example-cpu-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

# Create CloudWatch Alarm for Status Check Failed Instances
resource "aws_cloudwatch_metric_alarm" "status_check_alarm" {

  alarm_name          = "StatusCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 300 
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when there is at least 1 failed status check"
  alarm_actions       = [aws_sns_topic.example_sns_topic.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

# Create CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {

  depends_on = [ 
    aws_autoscaling_group.web_asg,
    aws_launch_template.web_launch_template 
    ]

  alarm_name          = "CPUUtilizationHigh"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 60
  alarm_description   = "Alarm when CPU exceeds 60% for 2 consecutive periods"
  alarm_actions       = [aws_autoscaling_policy.example_cpu_scale_out_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_sns_topic" "example_sns_topic" {
  name = "example-topic"
  
}

resource "aws_sns_topic_subscription" "example_email_subscription" {
  topic_arn = aws_sns_topic.example_sns_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

#Get Latest AWS AMI
data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}