#vpcの名前だけ入れる
module "dev-vpc" {
  source = "../../module/vpc"
}

module "dev-app" {
  source = "../../module/app"
  vpc_id = module.dev-vpc.vpd_id
}
