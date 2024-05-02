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
  profile             = "terraform" 
  region              = "ap-south-1" #var.region
}

module "vpc" {
  source  = "./modules/vpc"
  name                 = "example-vpc"
  cidr                 = "10.0.0.0/16"
  subnet_azs                = ["ap-south-1a", "ap-south-1b"]
  private_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs       = ["10.0.101.0/24", "10.0.102.0/24"]
  #enable_nat_gateway   = true
  #single_nat_gateway   = true
  #enable_dns_hostnames = true
}

module "security_group" {
  source = "./modules/security_group"
  name = "web_server"
  vpc_id = module.vpc.vpc_id
}

module "load_balancer" {
  source = "./modules/load_balancer"
  name              = "example-lb"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnet_ids
  security_group_id = module.security_group.security_group_id

}

module "autoscaling" {
  source = "./modules/autoscaling"
  name               = "example_asg"
  private_subnet_ids    = module.vpc.private_subnet_ids
  image_id          = "ami-013e83f579886baeb" #var.ami_id
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.key121.key_name
  security_group_id = module.security_group.security_group_id
  alb_tg_arn = module.load_balancer.load_balancer_target_group_arn
  user_data =  base64encode(<<EOF
#!/bin/bash
sudo yum update -y 
sudo yum install -y python3-pip 
sudo pip3 install ansible
sudo curl -OL https://raw.githubusercontent.com/ayusarin/Terraform-Assignment/ayush/terraform-webapp-deployment/ansible/playbook.yaml
sudo ansible-playbook -i localhost /playbook.yaml
EOF
)
  
}

module "bastion" {
  source            = "./modules/bastion"
  name              = "bastion"
  public_subnet_ids = module.vpc.public_subnet_ids
  image_id          = "ami-013e83f579886baeb" #var.ami_id
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.key121.key_name
  security_group_id = module.security_group.security_group_id

}

/*
module "route53" {
  source = "./modules/route53"
  private_zone_name = "example"
  region = var.region
  vpc_id  = module.vpc.vpc_id
}
*/