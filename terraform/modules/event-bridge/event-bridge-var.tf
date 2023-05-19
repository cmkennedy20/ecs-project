variable "ecs-cluster-arn" {
  type        = string
  description = "ECS cluster arn"
}
variable "ecs-task-arn" {
  type        = string
  description = "ECS task arn"
}
variable "subnets" {
    type = list(string)
    description = "A list of the different available subnets"
}