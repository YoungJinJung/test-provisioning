locals {
  name = "demoapp-xyzdapne2"

  container_name = "demoapp"
  container_port = 8080
  image          = "066346343248.dkr.ecr.ap-northeast-2.amazonaws.com/sample:dbf8b5ef7"
  tags = {
    Name = local.name
  }
}
