terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket       = "test-id-apnortheast2-tfstate"
    key          = "provisioning/terraform/route53/test-id/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

