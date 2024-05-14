#vpcの名前だけ入れる
module "dev-network" {
  source = "../../module/network"
  vpc_id = abs("dev")
}

module "dev-app" {
  source = "../../module/app"
  vpc_id = module.dev-vpc.vpd_id
}
