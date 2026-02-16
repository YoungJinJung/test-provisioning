resource "aws_iam_role" "codebuild_starter" {
  name = "codebuild-starter"
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.account_id.id}:role/app-jenkins"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_starter" {
  name = "codebuild-starter"
  role = aws_iam_role.codebuild_starter.id
  policy = jsonencode({
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : ["arn:aws:logs:*:*:log-group:/aws/codebuild/*"],
        "Action" : ["logs:GetLogEvents"]
      },
      {
        "Effect" : "Allow",
        "Resource" : ["arn:aws:codebuild:*:*:*"],
        "Action" : [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "codebuild:StopBuild"
        ]
      }
    ]
  })
}
