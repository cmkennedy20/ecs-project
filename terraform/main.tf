module "vpc" {
  source = "../../modules/vpc"
  azs    = var.TF_VAR_azs
}

module "ecs" {
  source      = "../../modules/ecs-cluster"
  task_role   = module.iam-roles.task_policy.arn
  subnet_list = module.vpc.subnet_list
  ecr_repo    = var.TF_VAR_ecr_repo
  alb_tg_arn  = module.alb.alb_tg_arn
  # ec2_ami = module.ami-select.ami-tag
  depends_on = [
    module.iam-roles, module.alb
  ]
}
