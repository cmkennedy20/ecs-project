# module "vpc" {
#   source = "./modules/vpc"
#   azs    = var.TF_VAR_azs
# }

module "ecs" {
  source = "./modules/ecs"
  # task_role   = module.iam-roles.task_policy.arn
  # subnet_list = module.vpc.subnet_list
  # ecr_repo    = var.TF_VAR_ecr_repo
  # alb_tg_arn  = module.alb.alb_tg_arn
  # depends_on = [
  #   module.iam-roles, module.alb
  # ]
}

module "event-bridge" {
  source          = "./modules/event-bridge"
  ecs-cluster-arn = module.ecs.ecs-cluster-arn
  ecs-task-arn    = module.ecs.ecs-task-arn
}