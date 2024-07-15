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

/*
module "security_group" {
  source = "./modules/security_group"
  sg_list = var.sg_list
  name = "web_server"
  alb_name = "alb_sg"
  bst_name = "bst_sg"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}
*/

module "sg" {
  source = "./modules/service1_sg"
  for_each = var.sg_list
  name   = each.key
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  
  additional_ingress_rules = each.value.additional_ingress_rules
  additional_egress_rules  = each.value.additional_egress_rules
}

/*
module "service1_sg" {
  source = "./modules/service1_sg"
  name   = "service1-sg"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr

  additional_ingress_rules = [ ]
}

module "service2_sg" {
  source = "./modules/service1_sg"
  name   = "service2-sg"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr

  additional_ingress_rules = [ ]

  additional_egress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      prefix_list_ids = []
    }
  ]
}

module "service3_sg" {
  source = "./modules/service1_sg"
  name   = "service3-sg"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr

  additional_ingress_rules = [  ]
}
*/