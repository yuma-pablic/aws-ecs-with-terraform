#vpcの名前だけ入れる
module "pro-vpc" {
  source = "../../module/vpc"
}

module "pro-app" {
  source = "../../module/app"
  vpc_id = module.dev-vpc.vpd_id
}

module "pro" {
  source                      = "../../module/db"
  vpc_id                      = module.pro-vpc.vpd_id
  vpce_sg_id                  = module.pro-app.vpce_sg.id
  sg-frontend-id              = module.pro-app.sg-frontend-id.id
  sg-backend-id               = module.pro-app.sg-backend-id.id
  sg-management-id            = module.pro-app.sg-management-id.id
  subnet-private-egress-1a-id = module.pro-app.subnet-private-egress-1a-id.id
  subnet-private-egress-1c-id = module.pro-app.subnet-private-egress-1c-id.id
}
