data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ebs_event" {
  name               = "ebs_event"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "ecs_events" {
  name               = "ecs_events"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "ecs_events_run_task_with_any_role" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = [replace(var.ecs-task-arn, "/:\\d+$/", ":*")]
  }
}
resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name   = "ecs_events_run_task_with_any_role"
  role   = aws_iam_role.ecs_events.id
  policy = data.aws_iam_policy_document.ecs_events_run_task_with_any_role.json
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run-scheduled-task-every-hour"
  arn       = var.ecs-cluster-arn
  rule      = aws_cloudwatch_event_rule.timer.name
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = var.ecs-task-arn
  }
}
resource "aws_cloudwatch_event_rule" "timer" {
  name                = "EventTimerRule"
  description         = "Timer to trigger ECS task"
  schedule_expression = "rate(3 minutes)"
}

resource "aws_scheduler_schedule" "example" {
    name = "my-schedule"
    schedule_expression = "rate(3 minute)"
    flexible_time_window {
        mode = "OFF"
    }
    target {
        arn      = var.ecs-cluster-arn
        role_arn = aws_iam_role.ecs_events.arn
        ecs_parameters {
            task_definition_arn = var.ecs-task-arn
        }
    }
}