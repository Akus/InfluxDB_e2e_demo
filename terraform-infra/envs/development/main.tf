module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_public_subnets   = var.vpc_public_subnets
  vpc_private_subnets  = var.vpc_private_subnets
  business_division    = var.business_division
  environment          = var.environment
  cluster_name         = var.cluster_name
  }

# module "compute" {
#   source      = "../../modules/compute"
#   environment = var.environment
#   vpc_id      = module.networking.vpc_id
# }

# module "storage" {
#   source      = "../../modules/storage"
#   environment = var.environment
#   vpc_id      = module.networking.vpc_id
# }

# module "monitoring" {
#   source      = "../../modules/monitoring"
#   environment = var.environment
#   vpc_id      = module.networking.vpc_id
# }