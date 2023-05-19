resource "aws_ecs_task_definition" "test-task" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "docker/getting-started"
      launch_type = ["FARGATE"]
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

resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.example.name
      }
    }
  }
}
resource "aws_cloudwatch_log_group" "example" {
  name = "example"
}

output "ecs-cluster-arn" {
  value = aws_ecs_cluster.test-cluster.arn
}
output "ecs-task-arn" {
  value = aws_ecs_task_definition.test-task.arn
}