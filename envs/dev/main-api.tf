# module "api-cluster" {
#   source       = "../../modules/api-cluster"
#   service      = var.service
#   env          = var.env
#   lisner_blue  = module.network.tg_blue_api_name
#   lisner_green = module.network.tg_green_api_name
# }
# module "api" {
#   source              = "../../modules/api"
#   env                 = var.env
#   service             = var.service
#   aws_caller_identity = ""
# }

# module "db" {
#   source                  = "../../modules/db"
#   env                     = var.env
#   service                 = var.service
#   vpc_id                  = module.network.vpc_id
#   sg_api_id               = module.network.sg_api_id
#   subnet_group            = module.network.db_sb_group_id
#   vpce_sg_id              = module.network.vpce_sg
#   sb_private_egress_1a_id = module.network.sb_private_egress_1a_id
#   sb_private_egress_1c_id = module.network.sb_private_egress_1c_id
#   sg_manage_id            = module.network.sg_management_id
#   sg_web_id               = module.network.sg_web_id
#   sg_db_id                = module.network.sg_db_subnet
# }

# module "devops" {
#   source  = "../../modules/devops"
#   env     = var.env
#   service = var.service
#   vpc_id  = module.network.vpc_id
# }

# module "monitoring" {
#   source  = "../../modules/manage"
#   env     = var.env
#   service = var.service
# }
