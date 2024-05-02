# Terraform-Assignment

This Terraform code wll create aws infra and will output public ALB and private DNS entry. ALB is accessible over port 80. At backend it runs ec2 managed by ASG, which is running nginx deployed using Ansible. Scaling happens on basis of CPU and ec2 state andf will trigger Alarm.

It can be run from any local windows machine or ec2 machine which has aws credentials updated in configure, no need to give any credentials in code. Proper permissions should be there for infra to be created.

**Info-**
variables.tfvars can be updated for
#aws region
region
vpc_subnet_azs

#vpc
vpc_name
vpc_cidr
vpc_private_subnet_cidr
vpc_public_subnet_cidr

#ec2
instance_type

#auto_scaling
alb_name
asg_name
min_size
max_size
desired_capacity

#cw_alarms using sns
alert_email

**To run terraform code**
run below cmds within folder terraform-webapp-deployment
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars" 

terrafoprm apply will give output with ALB and private dns entries.

**Modules-**
VPC - 
  -VPC, public & private subnet, Routetables, InternetGateway, NAT gateway
security_group- 
  - create security groups for alb, web server and bastion server (for mgmt)
bastion-
  - create ec2 in public subnet for accessing private ec2
load_blancer-
  - create alb, target group, listener
autoscaling-
  - create autoscaling group, launch template using latest AWS AMI, auto scaling policy on basis of cpu and status check
    cloudwatch alarm with sns.
route53 -
  - for creating private zone in route53
  - add alb record

terra_key.tf-> it will create pem key which is used by ec2.
    
Version used
Terraform v1.8.2
on windows_386
+ provider registry.terraform.io/hashicorp/aws v4.67.0
+ provider registry.terraform.io/hashicorp/local v2.5.1
+ provider registry.terraform.io/hashicorp/null v3.2.2
+ provider registry.terraform.io/hashicorp/tls v4.0.5
