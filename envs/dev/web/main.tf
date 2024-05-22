module "web" {
  source  = "../../modules/frontend-with-next"
  service = var.service
  env     = var.env
  vpc_id  = module.network.vpc_id
}

module "web-cluster" {
  source  = "../../modules/frontend-cluster"
  service = var.service
  env     = var.env
  vpc_id  = module.network.vpc_id
}
