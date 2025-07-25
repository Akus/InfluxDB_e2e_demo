locals {
  business_division = "akos-influxdb-eks"
  owners      = "akos-influxdb-eks"
  environment = "development"
  name        = "akos-influxdb-eks-development"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }

  # VPC Variables
  vpc_name = "akos-influxdb-eks-vpc"
  vpc_cidr_block = "10.0.0.0/16"
  #vpc_availability_zones = ["us-east-1a", "us-east-1b"]
  vpc_public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc_database_subnets= ["10.0.151.0/24", "10.0.152.0/24"]
  vpc_create_database_subnet_group = true 
  vpc_create_database_subnet_route_table = true   
  vpc_enable_nat_gateway = true  
  vpc_single_nat_gateway = true

  allowed_ssh_cidr_blocks = ["217.65.120.78/32"]

  cluster_name = "${local.business_division}-${local.environment}"
  cluster_service_ipv4_cidr = "172.20.0.0/16"
  cluster_version = "1.31"
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  eks_worker_node_instance_type = "t3.medium"
  eks_cluster_desired_size = 2
  eks_cluster_min_size = 2
  eks_cluster_max_size = 4

  argocd_helm_chart_version = "5.27.1"
}