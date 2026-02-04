terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state-bucket"
    key            = "prod/ecs/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
