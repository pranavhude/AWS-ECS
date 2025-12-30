resource "aws_instance" "this" {
  ami                    = "ami-0a8e758f5e873d1c1"
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [var.bastion_sg]
  key_name               = var.key_name
}
