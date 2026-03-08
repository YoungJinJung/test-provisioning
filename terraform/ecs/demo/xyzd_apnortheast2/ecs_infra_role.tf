data "aws_iam_policy_document" "ecs_infrastructure_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_infrastructure" {
  name               = "${local.name}-ecs-infra"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.ecs_infrastructure_assume_role.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs_infrastructure_load_balancer" {
  role       = aws_iam_role.ecs_infrastructure.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForLoadBalancers"
}
