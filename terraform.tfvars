#aws region
region = "ap-south-1"
vpc_subnet_azs = ["ap-south-1a", "ap-south-1b"]

#vpc
vpc_name = "example-vpc"
vpc_cidr = "10.0.0.0/16"
vpc_private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnet_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

sg_list = {
    "service1-sg" = {
      additional_ingress_rules = []
      additional_egress_rules = [
        {
          from_port      = 443
          to_port        = 443
          protocol       = "tcp"
          cidr_blocks    = ["0.0.0.0/0"]
          prefix_list_ids = []
        }
      ]
    },
    "service2-sg" = {
      additional_ingress_rules = []
      additional_egress_rules = []
    },
    "service3-sg" = {
      additional_ingress_rules = []
      additional_egress_rules = []
    }
  }