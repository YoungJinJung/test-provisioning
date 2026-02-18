
module "ephemeral_only_testdapne2" {
  source              = "../../../_modules/secretsmanager"
  key_name            = "ephemeral_only"
  env                 = "dev"
  rotation_lambda_arn = ""
  kms_arn             = data.terraform_remote_state.kms.outputs.aws_kms_key_apne2_deployment_common_arn
  tags = {
    app     = "ephemeral_only"
    project = "ephemeral_only"
  }
}

resource "aws_secretsmanager_secret_version" "ephemeral_only_testdapne2" {
  secret_id = module.ephemeral_only_testdapne2.id
  secret_string = sensitive(jsonencode(
    ephemeral.sops_file.ephemeral_testdapne2_only_value.data
  )
  )
}
