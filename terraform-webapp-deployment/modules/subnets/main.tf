# modules/subnet/main.tf
resource "aws_subnet" "example_subnet" {
  count                   = length(var.subnet_cidr_blocks)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name}-subnet-${count.index + 1}"
  }
}


