module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_public_subnets   = var.vpc_public_subnets
  vpc_private_subnets  = var.vpc_private_subnets
  business_division    = local.business_division
  environment          = local.environment
  cluster_name         = var.cluster_name
  }

module "compute_bastion" {
  depends_on = [ module.networking ]
  source               = "../../modules/compute/bastion"
  instance_type = var.instance_type
  business_division    = local.business_division
  environment          = local.environment
  vpc_id               = module.networking.vpc_id
  public_subnets       = module.networking.public_subnets
}

# module "compute_eks" {}

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