# module "web-cluster" {
#   source  = "../../modules/web-cluster"
#   service = var.service
#   env     = var.env
#   vpc_id  = module.network.vpc_id
# }

module "web" {
  source  = "../../modules/web"
  service = var.service
  env     = var.env
  alb_web = module.network.alb_web
}
