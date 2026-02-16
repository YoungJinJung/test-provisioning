terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "zerone-id-apnortheast2-tfstate"
    key            = "provisioning/terraform/services/demoapp/xyzd_apnortheast2/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    use_lockfile  = true
    assume_role = {
      role_arn = "arn:aws:iam::066346343248:role/terraform-runner"
    }
  }
}
