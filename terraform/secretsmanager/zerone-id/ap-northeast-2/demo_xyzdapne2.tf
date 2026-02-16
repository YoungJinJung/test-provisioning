
module "demo_xyzdapne2" {
  source              = "../../_module/secretsmanager"
  key_name            = "demo"
  env                 = "xyzdapne2"
  rotation_lambda_arn = ""
  kms_arn             = data.terraform_remote_state.kms.outputs.aws_kms_key_apne2_deployment_common_arn
  tags = {
    app     = "demoapp"
    project = "demo"
  }
}

resource "aws_secretsmanager_secret_version" "demo_xyzdapne2" {
  secret_id = module.demo_xyzdapne2.id
  secret_string = sensitive(jsonencode(
    data.sops_file.demo_xyzdapne2_value.data
    )
  )
}
