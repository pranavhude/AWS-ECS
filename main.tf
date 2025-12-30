module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "sg" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
  my_ip  = var.my_ip
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.sg.alb_sg
}

module "ecr" {
  source = "./modules/ecr"
}

module "iam" {
  source = "./modules/iam"
}

module "secrets" {
  source  = "./modules/secrets-manager"
  db_user = "admin"
  db_pass = "password123"
}

module "ecs" {
  source                = "./modules/ecs"
  private_subnets       = module.vpc.private_subnets
  ecs_sg                = module.sg.ecs_sg
  target_group_arn      = module.alb.target_group_arn
  ecr_image             = module.ecr.repo_url
  task_execution_role   = module.iam.task_execution_role
  instance_profile      = module.iam.instance_profile
  secret_arn            = module.secrets.secret_arn
}

module "rds" {
  source          = "./modules/rds"
  private_subnets = module.vpc.private_subnets
  rds_sg          = module.sg.rds_sg
}

module "bastion" {
  source        = "./modules/bastion"
  public_subnet = module.vpc.public_subnets[0]
  bastion_sg    = module.sg.bastion_sg
  key_name      = var.key_name
}

module "monitoring" {
  source = "./modules/monitoring"
}
