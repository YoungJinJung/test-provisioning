resource "aws_iam_role" "demoapp" {
  name               = "app-demoapp"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.demoapp_assume_role_document.json
}

data "aws_iam_policy_document" "demoapp_assume_role_document" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "demoapp_kms" {
  name   = "demoapp-kms-decryption"
  role   = aws_iam_role.demoapp.id
  policy = data.aws_iam_policy_document.demoapp_kms_ssm_document.json
}

data "aws_iam_policy_document" "demoapp_kms_ssm_document" {
  statement {
    sid    = "AllowToDecryptKMSKey"
    effect = "Allow"
    resources = [
      data.terraform_remote_state.kms.outputs.aws_kms_key_apne2_deployment_common_arn
    ]
    actions = [
      "kms:Decrypt"
    ]
  }

  statement {
    sid    = "AllowSsmParameterAccess"
    effect = "Allow"
    resources = [
      "arn:aws:ssm:ap-northeast-2:${var.account_id.id}:parameter/*"
    ]
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
  }
}

resource "aws_iam_instance_profile" "demoapp" {
  name = "demoapp-profile"
  role = aws_iam_role.demoapp.name
}

resource "aws_iam_role_policy_attachment" "demoapp_attach" {
  role       = aws_iam_role.demoapp.name
  policy_arn = aws_iam_policy.app_universal.arn
}

output "demoapp_instance_profile" {
  value = aws_iam_instance_profile.demoapp.arn
}

output "demoapp_arn" {
  value = aws_iam_role.demoapp.arn
}
