################################################################################
# Service
################################################################################
module "ecs_service" {
  source                      = "terraform-aws-modules/ecs/aws//modules/service"
  version                     = "7.4.0"
  name                        = local.name
  cluster_arn                 = module.ecs_cluster.arn
  infrastructure_iam_role_arn = aws_iam_role.ecs_infrastructure.arn
  create                      = true
  cpu                         = 1024
  memory                      = 4096

  volume = {
    my-vol = {}
  }

  deployment_controller = {
    type = "CODE_DEPLOY"
  }
  # deployment_configuration = {
  #   strategy             = "BLUE_GREEN"
  #   bake_time_in_minutes = 2
  # }
  create_tasks_iam_role     = false
  create_task_exec_iam_role = false
  task_exec_iam_role_arn    = data.terraform_remote_state.iam.outputs.sampleapp_task_exec_arn
  tasks_iam_role_arn        = data.terraform_remote_state.iam.outputs.sampleapp_task_arn

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

      mount_points = []

      # Example image used requires access to write to root filesystem
      readonlyRootFilesystem = false

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${local.name}/${local.container_name}"
      cloudwatch_log_group_retention_in_days = 7

      log_configuration = {
        logDriver = "awslogs"
      }
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["blue"].arn
      container_name   = local.container_name
      container_port   = local.container_port

      advanced_configuration = {
        alternate_target_group_arn = module.alb.target_groups["green"].arn
        production_listener_rule   = module.alb.listener_rules["blue/codedeploy"].arn
        role_arn                   = aws_iam_role.ecs_infrastructure.arn
        test_listener_rule         = module.alb.listener_rules["green/codedeploy"].arn
      }
    }
  }

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  # Create security group for the service
  create_security_group      = true
  security_group_name        = "${local.name}-service-sg"
  security_group_description = "Security group for ${local.name} ECS service"

  security_group_ingress_rules = {
    alb_ingress_8080 = {
      from_port                    = local.container_port
      to_port                      = local.container_port
      protocol                     = "tcp"
      description                  = "Service port"
      referenced_security_group_id = module.alb.security_group_id
    }
  }
  security_group_egress_rules = {
    egress_all = {
      from_port = 0
      to_port   = 65535
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
    }
  }

  service_tags = {
    "ServiceTag" = "Tag on service level"
  }

  tags = local.tags
}
