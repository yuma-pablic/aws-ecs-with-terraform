#vpcの名前だけ入れる
module "dev-network" {
  source = "../../module/network"
  vpc_id = module.dev-network.vpc_id
}
