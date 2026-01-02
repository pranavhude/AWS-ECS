data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "bastion" {
  ami = data.aws_ssm_parameter.amazon_linux.value
  instance_type = "t3.micro"
  ...
}
