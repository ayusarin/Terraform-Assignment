#aws region
region = "ap-south-1"
vpc_subnet_azs = ["ap-south-1a", "ap-south-1b"]

#vpc
vpc_name = "example-vpc"
vpc_cidr = "10.0.0.0/16"
vpc_private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnet_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

#ec2
instance_type = "t3.medium"

#auto_scaling using sns
alb_name = "example-lb"
asg_name = "example_asg"
min_size = 2
max_size = 4
desired_capacity = 2

#cw_alarms
alert_email = "ayu.sarin@gmail.com"