variable "sg_variables" {
  default = {
    external_lb = {
      tags = {
        xyzdapne2 = {
          Name    = "demoapp-xyzdapne2-external-lb-sg"
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
  }
}
