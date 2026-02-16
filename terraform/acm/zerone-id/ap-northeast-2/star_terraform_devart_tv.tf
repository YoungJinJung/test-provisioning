module "star_terraform_devart_tv" {
  source = "../_modules/acm"

  domain_name                        = "*.z.yz.tv"
  zone_id                            = var.r53_variables.z_y_z_zone_id
  subject_alternative_names          = ["x.y.z"]
  validation_allow_overwrite_records = true
  wait_for_validation                = true
}
