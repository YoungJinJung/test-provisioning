output "codedeploy_app_name" {
  value = aws_codedeploy_app.ecs.name
}

output "codedeploy_app_arn" {
  value = aws_codedeploy_app.ecs.arn
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.ecs.deployment_group_name
}

output "codedeploy_deployment_group_arn" {
  value = aws_codedeploy_deployment_group.ecs.arn
}

output "codedeploy_deployment_config_name" {
  value = aws_codedeploy_deployment_config.ecs.deployment_config_name
}

output "codedeploy_deployment_config_arn" {
  value = aws_codedeploy_deployment_config.ecs.arn
}
