resource "aws_instance" "bastion" {

  ami      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  availability_zone      = "ap-south-1a"
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.public_subnet_ids[0]


  tags = {
    Name =  var.name
  }

}