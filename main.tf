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
# IAM (ALL IAM LIVES HERE)
############################################

module "iam" {
  source = "./modules/iam"
}

############################################
# SECRETS MANAGER
############################################

module "secrets" {
  source = "./modules/secrets-manager"
  db_user = var.db_user
  db_pass = var.db_pass
}

############################################
# ECS
############################################

module "ecs" {
  source = "./modules/ecs"

  private_subnets     = module.vpc.private_subnets
  ecs_sg              = module.sg.ecs_sg
  target_group_arn    = module.alb.target_group_arn
  ecr_image           = module.ecr.repo_url
  task_execution_role = module.iam.task_execution_role
  instance_profile    = module.iam.instance_profile
  secret_arn          = module.secrets.secret_arn
}

############################################
# RDS
############################################

module "rds" {
  source          = "./modules/rds"
  private_subnets = module.vpc.private_subnets
  rds_sg          = module.sg.rds_sg
}

############################################
# BASTION
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

###########################################
# ecr 
###########################################
module "ecr" {
  source = "./modules/ecr"

  repo_name = "ecs-app-repo"
}

