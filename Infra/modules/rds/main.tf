resource "aws_db_subnet_group" "this" {
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "this" {
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg]
  username               = "admin"
  password               = "password123"
  publicly_accessible    = false
  skip_final_snapshot    = true
}
