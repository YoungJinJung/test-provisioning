resource "aws_iam_role" "terraform_runner" {
  name                 = var.role_name
  path                 = var.role_path
  max_session_duration = var.max_session_duration

  assume_role_policy = data.aws_iam_policy_document.policy_document.json
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.principal_account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy" "terraform_runner_passrole" {
  name   = "terraform-runner-passrole"
  role   = aws_iam_role.terraform_runner.id
  policy = data.aws_iam_policy_document.terraform_runner_passrole.json
}

data "aws_iam_policy_document" "terraform_runner_passrole" {
  statement {
    sid       = "AllowIAMPassRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }
}

#readonly
resource "aws_iam_role_policy_attachment" "terraform_runner_readonly" {
  role       = aws_iam_role.terraform_runner.id
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#s3
resource "aws_iam_role_policy" "terraform_runner_s3" {
  name   = "terraform-runner-s3"
  role   = aws_iam_role.terraform_runner.id
  policy = data.aws_iam_policy_document.terraform_runner_s3.json
}

data "aws_iam_policy_document" "terraform_runner_s3" {

  statement {
    sid    = "AllowTFBackendBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::*-apnortheast2-tfstate/*"
    ]
  }

  statement {
    sid    = "AllowTFBackendBucketList"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::*-apnortheast2-tfstate/*"
    ]
  }
}

#dynamodb
resource "aws_iam_role_policy" "terraform_runner_dynamodb" {
  name   = "terraform-runner-dynamodb-access"
  role   = aws_iam_role.terraform_runner.id
  policy = data.aws_iam_policy_document.terraform_runner_dynamodb.json
}

data "aws_iam_policy_document" "terraform_runner_dynamodb" {
  statement {
    sid    = "AllowDynamoDBAccess"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable"
    ]
    resources = [
      "arn:aws:dynamodb:ap-northeast-2:${var.account_id}:table/terraform-lock"
    ]
  }
}
