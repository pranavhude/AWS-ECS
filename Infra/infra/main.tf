############################################
# VPC
############################################
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

############################################
# SECURITY GROUPS
############################################
module "sg" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
  my_ip  = var.my_ip
}

############################################
# ALB
############################################
module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.sg.alb_sg
}

############################################
# ECR
############################################
module "ecr" {
  source    = "./modules/ecr"
  repo_name = "ecs-app-repo"
}

############################################
# IAM (ALL IAM LIVES HERE)
############################################
module "iam" {
  source = "./modules/iam"
}

############################################
# SECRETS MANAGER
############################################
module "secrets" {
  source  = "./modules/secrets-manager"
  db_user = var.db_user
  db_pass = var.db_pass
}

############################################
# ECS CLUSTER (CONTROL PLANE)
############################################
module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  cluster_name = "prod-ecs-cluster"
}

############################################
# ECS EC2 (CAPACITY PROVIDER)
############################################
module "ecs_ec2" {
  source = "./modules/ecs-ec2"

  cluster_name          = module.ecs_cluster.name
  private_subnets       = module.vpc.private_subnets
  ecs_sg_id             = module.sg.ecs_sg
  instance_profile_name = module.iam.ecs_instance_profile_name
}

############################################
# ECS SERVICE (TASK + SERVICE)
############################################
module "ecs_service" {
  source = "./modules/ecs-service"

  cluster_id                  = module.ecs_cluster.id
  ecr_image                   = module.ecr.repo_url
  target_group_arn            = module.alb.target_group_arn
  secret_arn                  = module.secrets.secret_arn
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn
  region                      = var.aws_region
}

############################################
# RDS (PRIVATE)
############################################
module "rds" {
  source          = "./modules/rds"
  private_subnets = module.vpc.private_subnets
  rds_sg          = module.sg.rds_sg
}

############################################
# BASTION HOST
############################################
module "bastion" {
  source        = "./modules/bastion"
  public_subnet = module.vpc.public_subnets[0]
  bastion_sg    = module.sg.bastion_sg
  key_name      = var.key_name
}

############################################
# MONITORING
############################################
module "monitoring" {
  source = "./modules/monitoring"
}

# trigger pipeline rightnow
