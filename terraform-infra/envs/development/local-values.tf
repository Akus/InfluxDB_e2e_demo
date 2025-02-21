locals {
  business_division = "akos-influxdb-eks"
  owners      = "akos-influxdb-eks"
  environment = "development"
  name        = "akos-influxdb-eks-development"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
  eks_cluster_name = "${local.name}-${var.cluster_name}"
}