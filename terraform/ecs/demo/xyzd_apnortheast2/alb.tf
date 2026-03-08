
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 10.0"

  name = local.name

  load_balancer_type = "application"

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = data.terraform_remote_state.vpc.outputs.public_subnets

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    https_prod = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "121.136.217.18/32"
    }
    http_test = {
      from_port   = 8443
      to_port     = 8443
      ip_protocol = "tcp"
      cidr_ipv4   = "121.136.217.18/32"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  route53_records = {
    demo = {
      zone_id = var.r53_variables.terraform_devart_tv_zone_id
      name    = local.container_name
      type    = "A"
    }
  }
  listeners = {
    blue = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.r53_variables.star_terraform_devart_tv_acm_apne2_arn
      forward = {
        target_group_key = "blue"
      }
      rules = {
        codedeploy = {
          priority = 100
          actions = [
            {
              forward = {
                target_group_key = "blue"
              }
            }
          ]
          conditions = [
            {
              path_pattern = {
                values = ["/*"]
              }
            }
          ]
        }
      }
    },
    green = {
      port     = 8443
      protocol = "HTTP"

      forward = {
        target_group_key = "green"
      }
      rules = {
        codedeploy = {
          priority = 100
          actions = [
            {
              forward = {
                target_group_key = "green"
              }
            }
          ]
          conditions = [
            {
              path_pattern = {
                values = ["/*"]
              }
            }
          ]
        }
      }
    }
  }

  target_groups = {
    blue = {
      name                              = "${local.container_name}-blue"
      protocol                          = "HTTP"
      port                              = local.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/actuator/health"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

    green = {
      name                              = "${local.container_name}-green"
      protocol                          = "HTTP"
      port                              = local.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/actuator/health"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

    # There's nothing to attach here in this definition. Instead,
    # ECS will attach the IPs of the tasks to this target group
  }
  tags = local.tags
}
