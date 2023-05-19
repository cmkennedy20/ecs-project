module "vpc" {
  source = "./modules/vpc"
  azs    = var.TF_VAR_azs
}

module "ecs" {
  source = "./modules/ecs"
  subnets = module.vpc.subnet_list
}

module "event-bridge" {
  source          = "./modules/event-bridge"
  ecs-cluster-arn = module.ecs.ecs-cluster-arn
  ecs-task-arn    = module.ecs.ecs-task-arn
  subnets = module.vpc.subnet_list
}