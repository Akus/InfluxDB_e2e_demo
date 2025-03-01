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
  cluster_name = local.cluster_name
  vpc_id = module.networking.vpc_id
  cluster_service_ipv4_cidr = local.cluster_service_ipv4_cidr
  cluster_version      = local.cluster_version
  cluster_endpoint_private_access = local.cluster_endpoint_private_access
  cluster_endpoint_public_access = local.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs
  business_division    = local.business_division
  environment          = local.environment
#  public_subnets       = module.networking.public_subnets
  vpc_private_subnets       = module.networking.private_subnets
  eks_worker_node_instance_type = local.eks_worker_node_instance_type
  eks_cluster_desired_size = local.eks_cluster_desired_size
  eks_cluster_min_size = local.eks_cluster_min_size
  eks_cluster_max_size = local.eks_cluster_max_size
}

module "storage" {
  source      = "../../modules/storage"
  cluster_name = local.cluster_name
  k8s_namespace = "influxdb"
  eks_node_group_security_group_id = module.compute_eks.eks_node_group_security_group_id
  vpc_private_subnets = module.networking.private_subnets
}

module "argocd" {
  source      = "../../modules/argocd"
  cluster_name = local.cluster_name
  region = var.aws_region
  argocd_namespace = "argocd"
  argocd_helm_chart_version = local.argocd_helm_chart_version
}

# module "monitoring" {
#   source      = "../../modules/monitoring"
#   environment = var.environment
#   vpc_id      = module.networking.vpc_id
# }