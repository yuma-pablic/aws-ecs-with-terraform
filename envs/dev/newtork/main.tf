module "network" {
  source  = "../../modules/network"
  service = var.service
  env     = var.env
}
