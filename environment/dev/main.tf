#vpcの名前だけ入れる
module "dev-vpc" {
  source = "../../module/vpc"
}

module "dev-app" {
  source = "../../module/app"
  vpc_id = module.dev-vpc.vpd_id
}

module "dev-db" {
  source                      = "../../module/db"
  vpc_id                      = module.dev-vpc.vpd_id
  vpce_sg_id                  = module.dev-app.vpce_sg.id
  sg-frontend-id              = module.dev-app.sg-frontend-id.id
  sg-backend-id               = module.dev-app.sg-backend-id.id
  sg-management-id            = module.dev-app.sg-management-id.id
  subnet-private-egress-1a-id = module.dev-app.subnet-private-egress-1a-id.id
  subnet-private-egress-1c-id = module.dev-app.subnet-private-egress-1c-id.id
}
