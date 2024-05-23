#Hello
module "network" {
  source  = "../../module/network"
  vpc_id  = "vpc-12345678"
  env     = "stage"
  service = "main"
}
