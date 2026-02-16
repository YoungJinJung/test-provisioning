resource "aws_iam_role" "sampleapp_task_exec" {
  name               = "app-sampleapp-task-exec"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sampleapp_task_exec_assume_role_document.json
}

data "aws_iam_policy_document" "sampleapp_task_exec_assume_role_document" {
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

resource "aws_iam_role_policy_attachment" "sampleapp_task_exec_attach" {
  role       = aws_iam_role.sampleapp_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

output "sampleapp_task_exec_arn" {
  value = aws_iam_role.sampleapp_task_exec.arn
}
