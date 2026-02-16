################################################################################
# Service
################################################################################
module "ecs_service" {
  source      = "terraform-aws-modules/ecs/aws//modules/service"
  version     = "7.3.0"
  name        = local.name
  cluster_arn = module.ecs_cluster.cluster_arn

  cpu    = 2048
  memory = 8192

  deployment_configuration = {
    strategy             = "BLUE_GREEN"
    bake_time_in_minutes = 2
  }

  create_tasks_iam_role     = false
  create_task_exec_iam_role = false
  task_exec_iam_role_arn    = data.terraform_remote_state.iam.outputs.demo_xyzdapne2_task_exec_arn
  tasks_iam_role_arn        = data.terraform_remote_state.iam.outputs.demo_xyzdapne2_task_arn
  # Container definition(s)
  container_definitions = {
    (local.container_name) = {
      image = local.image
      portMappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]

      mount_points = [
      ]

      # Example image used requires access to write to root filesystem
      readonlyRootFilesystem = false

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${local.name}/${local.container_name}"
      cloudwatch_log_group_retention_in_days = 7

      logConfiguration = {
        logDriver = "awslogs"
      }
    }
  }



  load_balancer = {
    blue = {
      target_group_arn = module.alb.target_groups["blue"].arn
      container_name   = local.container_name
      container_port   = local.container_port
      advanced_configuration = {
        alternate_target_group_arn = module.alb.target_groups["green"].arn
        production_listener_rule   = module.alb.listener_rules["blue/production"].arn
        test_listener_rule         = module.alb.listener_rules["blue/test"].arn
      }
    }
    # green = {
    #   target_group_arn = module.alb.target_groups["green"].arn
    #   container_name   = local.container_name
    #   container_port   = local.container_port
    # }
  }

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  security_group_ingress_rules = {
    alb_ingress_8080 = {
      type                         = "ingress"
      from_port                    = local.container_port
      to_port                      = local.container_port
      protocol                     = "tcp"
      description                  = "Service port"
      referenced_security_group_id = module.alb.security_group_id
    }
  }
  security_group_egress_rules = {
    all = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }

  service_tags = {
    "ServiceTag" = "Tag on service level"
  }

  tags = local.tags
}
