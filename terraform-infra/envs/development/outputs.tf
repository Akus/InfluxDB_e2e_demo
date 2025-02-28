output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

# output "public_subnets" {
#   description = "List of public subnet IDs"
#   value       = module.networking.public_subnets
# }

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnets
}

# output "s3_bucket_name" {
#   description = "The name of the S3 bucket"
#   value       = module.storage.s3_bucket_name
# }

output "eks_node_group_security_group_id" {
  description = "Security group ID of the EKS node group"
  value       = module.compute_eks.eks_node_group_security_group_id
}