variable "lb_variables" {
  default = {

    target_group_slow_start = {
      xyzdapne2 = 60
    }

    target_group_deregistration_delay = {
      xyzdapne2 = 60
    }

    external_lb = {
      tags = {
        xyzdapne2 = {
          Name    = "demoapp-xyzdapne2-external-lb"
          app     = "demoapp"
          project = "demoapp"
          env     = "dev"
          stack   = "xyzdapne2"
        }
      }
    }

    external_lb_tg = {
      tags = {
        xyzdapne2 = {
          Name    = "demoapp-xyzdapne2-external-tg"
          app     = "demoapp"
          project = "demoapp"
          env     = "dev"
          stack   = "xyzdapne2"
        }
      }
    }
    
    internal_lb = {
      tags = {
      }
    }

    internal_lb_tg = {
      tags = {
      }
    }
  }
}
