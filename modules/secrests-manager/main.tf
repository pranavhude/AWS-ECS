resource "aws_secretsmanager_secret" "this" {
  name = "db-credentials"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.db_user
    password = var.db_pass
  })
}

output "secret_arn" {
  value = aws_secretsmanager_secret.this.arn
}
