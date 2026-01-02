############################################
# AMAZON LINUX 2023 AMI (SSM)
############################################

data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

############################################
# BASTION HOST
############################################

resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.amazon_linux.value
  instance_type           = "t3.micro"
  subnet_id               = var.public_subnet
  vpc_security_group_ids  = [var.bastion_sg]
  key_name                = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

