provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "test-id-apnortheast2-tfstate"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}