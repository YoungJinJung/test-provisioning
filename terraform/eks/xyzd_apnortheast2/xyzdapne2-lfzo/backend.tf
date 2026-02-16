terraform {
  required_version = ">= 1.12.0"

  backend "s3" {
    bucket         = "test-id-apnortheast2-tfstate"
    key            = "provisioning/terraform/eks/xyzd_apnortheast2/xyzdapne2-lfzo/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    use_lockfile = true
  }
}
