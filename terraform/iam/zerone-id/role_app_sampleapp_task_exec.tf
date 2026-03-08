resource "aws_iam_role" "app_sampleapp_task_exec" {
  name               = "app-sampleapp-task-exec"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.app_sampleapp_task_exec_assume_role_document.json
}

data "aws_iam_policy_document" "app_sampleapp_task_exec_assume_role_document" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role_policy" "app_sampleapp_task_exec_policy" {
  name   = "task_exec_policy"
  role   = aws_iam_role.app_sampleapp_task_exec.id
  policy = data.aws_iam_policy_document.app_sampleapp_task_exec_policy.json

}

data "aws_iam_policy_document" "app_sampleapp_task_exec_policy" {
  statement {
    sid    = "ECR"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Log"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = ["*"]
  }
}

output "sampleapp_task_exec_arn" {
  value = aws_iam_role.app_sampleapp_task_exec.arn
}
