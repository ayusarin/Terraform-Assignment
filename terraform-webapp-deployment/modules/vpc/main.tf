# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  
  #enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidrs)
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.public_subnet_cidrs[count.index]
  availability_zone      = var.subnet_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                  = length(var.private_subnet_cidrs)
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.private_subnet_cidrs[count.index]
  availability_zone      = var.subnet_azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

# Creating an Internet Gateway for the VPC
resource "aws_internet_gateway" "Internet_Gateway" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_subnet.private
  ]

  # VPC in which it has to be created!
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IG-Public-VPC"
  }
}



# Creating an Route Table for the public subnet!
resource "aws_route_table" "Public-Subnet-RT" {
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.Internet_Gateway
  ]

  # VPC ID
  vpc_id = aws_vpc.main.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}


  # Creating a resource for the Route Table Association!
resource "aws_route_table_association" "RT-IG-Association" {

  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_subnet.private,
    aws_route_table.Public-Subnet-RT
  ]

  count     = length(var.public_subnet_cidrs)  # Use the length of the list
  subnet_id = aws_subnet.public[count.index].id  # Access subnet_id with count.index

  #  Route Table ID
  route_table_id = aws_route_table.Public-Subnet-RT.id
}

resource "aws_eip" "my_eip" {
  # Optionally specify the VPC ID if you are using a VPC
  vpc = true
}

#Create Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {

  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_subnet.private,
    aws_eip.my_eip
  ]

  allocation_id = aws_eip.my_eip.id

  subnet_id = aws_subnet.public[0].id  # Access subnet_id with count.index

  tags = {
    Name = "NAT-GAT"
  }

}

resource "aws_route_table" "Private-Subnet-RT" {
  depends_on = [
    aws_vpc.main,
    aws_nat_gateway.nat_gateway
  ]

  # VPC ID
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Route Table for NAT Gateway"
  }
}

resource "aws_route" "nat_gateway_route" {

  depends_on = [
    aws_route_table.Private-Subnet-RT
  ]

  route_table_id         = aws_route_table.Private-Subnet-RT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

  # Creating a resource for the Route Table Association!
resource "aws_route_table_association" "RT-NAT-Association" {

  depends_on = [
    aws_route.nat_gateway_route
  ]

  count     = length(var.private_subnet_cidrs)  # Use the length of the list
  subnet_id = aws_subnet.private[count.index].id  # Access subnet_id with count.index

  #  Route Table ID
  route_table_id = aws_route_table.Private-Subnet-RT.id
}