locals {
  name = "demo-xyzdapne2"

  container_name = "demo"
  container_port = 8080
  image          = "066346343248.dkr.ecr.ap-northeast-2.amazonaws.com/sample:d4d0f21f5"
  tags = {
    Name = local.name
  }
}
