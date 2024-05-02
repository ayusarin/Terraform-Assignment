# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  #profile             = "terraform" 
  region              = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  subnet_azs                = var.vpc_subnet_azs
  private_subnet_cidrs      = var.vpc_private_subnet_cidr
  public_subnet_cidrs       = var.vpc_public_subnet_cidr
}

module "security_group" {
  source = "./modules/security_group"
  name = "web_server"
  alb_name = "alb_sg"
  bst_name = "bst_sg"
  vpc_id = module.vpc.vpc_id
}

module "load_balancer" {
  source = "./modules/load_balancer"
  name              = var.alb_name
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnet_ids
  security_group_id = module.security_group.alb_security_group_id

}

module "autoscaling" {
  source = "./modules/autoscaling"
  name               = var.asg_name
  private_subnet_ids = module.vpc.private_subnet_ids
  image_id          = "ami-013e83f579886baeb" #default ami
  instance_type     = var.instance_type
  key_name          = aws_key_pair.key121.key_name
  security_group_id = module.security_group.web_security_group_id
  alb_tg_arn = module.load_balancer.load_balancer_target_group_arn
  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity
  alert_email = var.alert_email
  user_data =  base64encode(<<EOF
#!/bin/bash
sudo yum update -y 
sudo yum install -y python3-pip 
sudo pip3 install ansible
sudo curl -OL https://raw.githubusercontent.com/ayusarin/Terraform-Assignment/ayush/terraform-webapp-deployment/ansible/playbook.yaml
ansible-playbook -i localhost /playbook.yaml
EOF
)
  
}

module "bastion" {
  source            = "./modules/bastion"
  name              = "bastion"
  public_subnet_ids = module.vpc.public_subnet_ids
  image_id          = "ami-013e83f579886baeb" #var.ami_id
  instance_type     = var.instance_type
  key_name          = aws_key_pair.key121.key_name
  security_group_id = module.security_group.bst_security_group_id

}

module "route53" {
  source = "./modules/route53"
  private_zone_name = "example.local"
  region = var.region
  vpc_id  = module.vpc.vpc_id
  alb_dns_name = module.load_balancer.load_balancer_dns_name
  alb_zone_id = module.load_balancer.load_balancer_zone_id
}