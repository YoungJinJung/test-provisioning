resource "aws_iam_role" "sampleapp_task" {
  name               = "app-sampleapp-task"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sampleapp_task_assume_role_document.json
}

data "aws_iam_policy_document" "sampleapp_task_assume_role_document" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

output "sampleapp_task_arn" {
  value = aws_iam_role.sampleapp_task.arn
}
