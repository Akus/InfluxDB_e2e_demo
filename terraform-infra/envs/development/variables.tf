variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "eks-cluster"
}

variable "business_division" {
  description = "The business division"
  type        = string
}