# modules/security_group/main.tf

#WebServer Security Group
resource "aws_security_group" "web_sg" {
  name        = var.name
  description = "Security group for web servers"
  
  vpc_id = var.vpc_id

  // Ingress rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allowing HTTP traffic from vpc
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allowing HTTPS traffic from vpc
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allowing SSH traffic from vpc
  }

  // Egress rules
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"  # Allow all HTTPS outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"  # Allow all HTTP outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = var.alb_name
  description = "Security group for ALB"
  
  vpc_id = var.vpc_id

  // Ingress rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing HTTP traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing HTTPS traffic from anywhere
  }

  // Egress rules
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"  # Allow HTTP outbound traffic within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"  # Allow HTTPS outbound traffic within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

}

#Bastion Security Group
resource "aws_security_group" "bst_sg" {
  name        = var.bst_name
  description = "Security group for bst"
  
  vpc_id = var.vpc_id

  // Ingress rules

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing SSH traffic from anywhere (for management)
  }

  // Egress rules
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  # Allow all outbound traffic for ssh within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

    egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"  # Allow all HTTPS traffic for ssh within VPC
    cidr_blocks = ["0.0.0.0/16"]
  }

      egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"  # Allow all outbound traffic for ssh within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

        egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"  # Allow all outbound traffic for ssh within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

}