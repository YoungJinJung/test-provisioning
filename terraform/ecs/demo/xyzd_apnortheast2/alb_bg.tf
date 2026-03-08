# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 10.0"

#   name = local.name

#   load_balancer_type = "application"

#   vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
#   subnets = data.terraform_remote_state.vpc.outputs.public_subnets

#   # For example only
#   enable_deletion_protection = false

#   # Security Group
#   security_group_ingress_rules = {
#     all_https = {
#       from_port   = 443
#       to_port     = 443
#       ip_protocol = "tcp"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#   }
#   security_group_egress_rules = {
#     all = {
#       ip_protocol = "-1"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#   }

#   listeners = {
#     ex-http = {
#       port     = 80
#       protocol = "HTTP"

#       fixed_response = {
#         content_type = "text/plain"
#         message_body = "404: Page not found"
#         status_code  = "404"
#       }

#       # for blue/green deployments
#       rules = {
#         production = {
#           priority = 1
#           actions = [
#             {
#               weighted_forward = {
#                 target_groups = [
#                   {
#                     target_group_key = "ex-ecs"
#                     weight           = 100
#                   },
#                   {
#                     target_group_key = "ex-ecs-alternate"
#                     weight           = 0
#                   }
#                 ]
#               }
#             }
#           ]
#           conditions = [
#             {
#               path_pattern = {
#                 values = ["/*"]
#               }
#             }
#           ]
#         }
#         test = {
#           priority = 2
#           actions = [
#             {
#               weighted_forward = {
#                 target_groups = [
#                   {
#                     target_group_key = "ex-ecs-alternate"
#                     weight           = 100
#                   }
#                 ]
#               }
#             }
#           ]
#           conditions = [
#             {
#               path_pattern = {
#                 values = ["/*"]
#               }
#             }
#           ]
#         }
#       }
#     }
#   }

#   target_groups = {
#     ex-ecs = {
#       backend_protocol                  = "HTTP"
#       backend_port                      = local.container_port
#       target_type                       = "ip"
#       deregistration_delay              = 5
#       load_balancing_cross_zone_enabled = true


#       health_check = {
#         enabled             = true
#         healthy_threshold   = 5
#         interval            = 30
#         matcher             = "200"
#         path                = "/actuator/health"
#         port                = "traffic-port"
#         protocol            = "HTTP"
#         timeout             = 5
#         unhealthy_threshold = 2
#       }

#       # There's nothing to attach here in this definition. Instead,
#       # ECS will attach the IPs of the tasks to this target group
#       create_attachment = false
#     }

#     # for blue/green deployments
#     ex-ecs-alternate = {
#       backend_protocol                  = "HTTP"
#       backend_port                      = local.container_port
#       target_type                       = "ip"
#       deregistration_delay              = 5
#       load_balancing_cross_zone_enabled = true


#       health_check = {
#         enabled             = true
#         healthy_threshold   = 5
#         interval            = 30
#         matcher             = "200"
#         path                = "/actuator/health"
#         port                = "traffic-port"
#         protocol            = "HTTP"
#         timeout             = 5
#         unhealthy_threshold = 2
#       }

#       # There's nothing to attach here in this definition. Instead,
#       # ECS will attach the IPs of the tasks to this target group
#       create_attachment = false
#     }
#   }
#   route53_records = {
#     sampleapp = {
#       zone_id = var.r53_variables.terraform_devart_tv_zone_id
#       name    = "sampleapp"
#       type    = "A"
#     }
#   }
#   tags = local.tags
# }