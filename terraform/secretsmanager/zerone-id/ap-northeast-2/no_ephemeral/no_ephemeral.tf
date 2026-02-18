
module "no_ephemeral_testdapne2" {
  source              = "../../../_modules/secretsmanager"
  key_name            = "no_ephemeral"
  env                 = "dev"
  rotation_lambda_arn = ""
  kms_arn             = data.terraform_remote_state.kms.outputs.aws_kms_key_apne2_deployment_common_arn
  tags = {
    app     = "no_ephemeral"
    project = "no_ephemeral"
  }
}

resource "aws_secretsmanager_secret_version" "no_ephemeral_testdapne2" {
  secret_id = module.no_ephemeral_testdapne2.id
  secret_string  = sensitive(jsonencode(
    data.sops_file.no_ephemeral_testdapne2_value.data
    )
  )
}
