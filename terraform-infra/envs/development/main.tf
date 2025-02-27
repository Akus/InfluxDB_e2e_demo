module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_public_subnets   = var.vpc_public_subnets
  vpc_private_subnets  = var.vpc_private_subnets
  business_division    = local.business_division
  environment          = local.environment
}

module "bastion" {
  source = "../../modules/compute/my_bastion"
  aws_region             = var.aws_region
  vpc_id             = module.networking.vpc_id
  public_subnets     = module.networking.public_subnets
  key_name           = var.instance_keypair
  name_prefix        = "akos-influxdb"
  instance_type      = var.instance_type
  allowed_ssh_cidr_blocks = local.allowed_ssh_cidr_blocks
  
  tags = {
    Environment = "Development"
    Project     = "InfluxDB"
  }
}

module "compute_eks" {
  depends_on = [ module.networking ]

  source               = "../../modules/compute/eks"
  cluster_service_ipv4_cidr = local.cluster_service_ipv4_cidr
  cluster_version      = local.cluster_version
  cluster_endpoint_private_access = local.cluster_endpoint_private_access
  cluster_endpoint_public_access = local.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs
  business_division    = local.business_division
  environment          = local.environment
#  public_subnets       = module.networking.public_subnets
  vpc_private_subnets       = module.networking.private_subnets
}

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