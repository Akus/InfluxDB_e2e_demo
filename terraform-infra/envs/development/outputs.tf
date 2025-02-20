output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnets
}

# output "eks_cluster_name" {
#   description = "The name of the EKS cluster"
#   value       = module.compute.eks_cluster_name
# }

# output "s3_bucket_name" {
#   description = "The name of the S3 bucket"
#   value       = module.storage.s3_bucket_name
# }
