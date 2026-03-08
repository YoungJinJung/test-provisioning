
module "no_ephemeral_wo_testdapne2" {
  source              = "../../../_modules/secretsmanager"
  key_name            = "no_ephemeral_wo"
  env                 = "dev"
  rotation_lambda_arn = ""
  kms_arn             = data.terraform_remote_state.kms.outputs.aws_kms_key_apne2_deployment_common_arn
  tags = {
    app     = "no_ephemeral_wo"
    project = "no_ephemeral_wo"
  }
}

resource "aws_secretsmanager_secret_version" "no_ephemeral_wo_testdapne2" {
  secret_id = module.no_ephemeral_wo_testdapne2.id
  secret_string_wo  = jsonencode(
    data.sops_file.no_ephemeral_testdapne2_value.data
  )
  secret_string_wo_version = 1
}
