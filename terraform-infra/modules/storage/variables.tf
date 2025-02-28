variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"  # Change this to your preferred region
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "storage_size" {
  description = "Size of the EFS storage in GiB"
  type        = number
  default     = 50  
}

variable "eks_node_group_security_group_id" {
  description = "Security group ID of the EKS node group"
  type        = string
  
}

variable "vpc_private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default = [ "subnet-07547ef6e8e74a57c" ]
}

variable "k8s_namespace" {
  description = "Kubernetes namespace"
  type        = string
  
}