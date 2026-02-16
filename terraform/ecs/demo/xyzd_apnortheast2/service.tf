################################################################################
# Service
################################################################################
module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "7.3.0"

  name        = local.name
  cluster_arn = module.ecs_cluster.arn
  memory      = 4096

  volume = {
    my-vol = {}
  }
  # deployment_controller = {
  #   type = "CODE_DEPLOY"
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

      mountPoints = [
      ]

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
    blue = {
      target_group_arn = module.alb.target_groups["blue"].arn
      container_name   = local.container_name
      container_port   = local.container_port
    }
    green = {
      target_group_arn = module.alb.target_groups["green"].arn
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
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
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  service_tags = {
    "ServiceTag" = "Tag on service level"
  }

  tags = local.tags
}
