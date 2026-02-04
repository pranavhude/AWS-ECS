variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "azs" {}
variable "my_ip" {}
variable "key_name" {}
variable "db_user" {
  type = string
}

variable "db_pass" {
  type      = string
  sensitive = true
}

