
module "ephemeral_testdapne2" {
  source              = "../../../_modules/secretsmanager"
  key_name            = "ephemeral"
  env                 = "dev"
  rotation_lambda_arn = ""
  kms_arn             = data.terraform_remote_state.kms.outputs.aws_kms_key_apne2_deployment_common_arn
  tags = {
    app     = "ephemeral"
    project = "ephemeral"
  }
}

resource "aws_secretsmanager_secret_version" "ephemeral_testdapne2" {
  secret_id = module.ephemeral_testdapne2.id
  secret_string_wo = jsonencode(
    ephemeral.sops_file.ephemeral_testdapne2_value.data
  )
  secret_string_wo_version = 2
}
