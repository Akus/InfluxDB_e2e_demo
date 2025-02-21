locals {
  owners      = var.business_division
  environment = var.environment
  instance_keypair = "eks-terraform-key"
  name        = "${var.business_division}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}