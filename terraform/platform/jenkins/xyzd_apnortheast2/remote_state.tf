data "terraform_remote_state" "kms_apne2" {
  backend = "s3"
  config  = merge(var.remote_state.kms.zerone-id.apne2,  { "role_arn" = var.assume_role_arn })
  # config = merge(var.remote_state.kms.zerone-id.apne2,  {"assume_role" = { "role_arn" = var.assume_role_arn }})
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config  = merge(var.remote_state.vpc.xyzd_apnortheast2,  { "role_arn" = var.assume_role_arn })
  # config = merge(var.remote_state.vpc.xyzd_apnortheast2, { "assume_role" = { "role_arn" = var.assume_role_arn } })

}

