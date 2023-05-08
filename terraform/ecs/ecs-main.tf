resource "aws_ecs_task_definition" "test-task" {
  family = "service"
requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "test-service" {
  name                = "bar"
  cluster             = aws_ecs_cluster.test-cluster.id
  task_definition     = aws_ecs_task_definition.test-task.arn
  scheduling_strategy = "DAEMON"
}

resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}