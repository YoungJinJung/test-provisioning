resource "aws_s3_bucket" "sample_deployment" {
  bucket = "zerone-id-service-deployment"
}

resource "aws_s3_bucket_accelerate_configuration" "sample_deployment_accelerate_configuration" {
  bucket = aws_s3_bucket.sample_deployment.id
  status = "Enabled"
}

resource "aws_s3_bucket_policy" "sample_deployment_bucket_policy" {
  bucket = aws_s3_bucket.sample_deployment.id
  policy = data.aws_iam_policy_document.sample_deployment_bucket_policy_document.json
}

data "aws_iam_policy_document" "sample_deployment_bucket_policy_document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.account_id.id}"]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.sample_deployment.arn,
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.account_id.id}"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.sample_deployment.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "sample_deployment_lifecycle_configuration" {
  bucket = aws_s3_bucket.sample_deployment.id

  rule {
    id     = "intelligent-tiering"
    status = "Enabled"
    filter {
      
    }
    transition {
      days          = 3
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}
