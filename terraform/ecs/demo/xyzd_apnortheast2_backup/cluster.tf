module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = local.name

  # Capacity provider
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
