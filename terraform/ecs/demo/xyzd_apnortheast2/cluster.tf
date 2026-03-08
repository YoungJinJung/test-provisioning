module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  name = local.name

  # Configuration
  configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${local.name}"
      }
    }
  }

  # Cluster capacity providers
  cluster_capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 1
      base   = 1
    }
    FARGATE_SPOT = {
      weight = 1
    }
  }

  tags = local.tags
}
