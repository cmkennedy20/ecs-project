resource "aws_iam_role" "ecs_execution_role"{
  name = "ecs-execute-schedule-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_policy_doc.json 
}


data "aws_iam_policy_document" "ecs_execution_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com",
        "scheduler.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "aws_ecs_execution_policy"{
  name = "execution-role"
  role = aws_iam_role.ecs_execution_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_scheduler_schedule" "example" {
    name = "my-schedule"
    schedule_expression = "rate(3 minute)"
    flexible_time_window {
        mode = "OFF"
    }
    
    target {
        arn      = var.ecs-cluster-arn
        role_arn = aws_iam_role.ecs_execution_role.arn
        ecs_parameters {
          task_definition_arn = var.ecs-task-arn
          launch_type = "FARGATE"
          network_configuration {
            subnets = var.subnets
          }
        }
        dead_letter_config {
          arn = aws_sqs_queue.dlq_queue.arn
        }
    }
}

resource "aws_sqs_queue" "dlq_queue" {
  name = "eventbridge_schedule_dlq"
}