# modules/autoscaling/main.tf
resource "aws_autoscaling_group" "web_asg" {

  name             = var.name
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  health_check_type                 = "ELB"
  health_check_grace_period         = 300
  wait_for_capacity_timeout         = "10m"
  termination_policies              = ["Default"]
}

resource "aws_launch_template" "web_launch_template" {
  name_prefix   = var.name
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.root_volume_size
      volume_type = "gp3"
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = var.log_volume_size
      volume_type = "gp3"
    }
  }
}


