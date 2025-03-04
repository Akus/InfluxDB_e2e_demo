# EKS Cluster Input Variables

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string  
}

variable "vpc_id" {
  description = "The VPC ID to create the EKS cluster within."
  type        = string  
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  
}

variable "vpc_private_subnets" {
  description = "List of private subnets to place the EKS cluster and workers within."
  type        = list(string)
  
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.21)"
  type = string
  default     = null
}
variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# EKS Node Group Variables
## Placeholder space you can create if required

variable "business_division" {
  description = "The business division"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., development, staging, production)"
  type        = string
}

variable "storage_size" {
  description = "Size of the EFS storage in GiB"
  type        = number
  default     = 8  
}

variable "eks_worker_node_instance_type" {
  description = "The instance type to use for the EKS worker nodes"
  type        = string
  
}

variable "eks_cluster_desired_size" {
  description = "The desired number of worker nodes for the EKS cluster"
  type        = number 
}

variable "eks_cluster_min_size" {
  description = "The minimum number of worker nodes for the EKS cluster"
  type        = number 
}

variable "eks_cluster_max_size" {
  description = "The maximum number of worker nodes for the EKS cluster"
  type        = number 
}