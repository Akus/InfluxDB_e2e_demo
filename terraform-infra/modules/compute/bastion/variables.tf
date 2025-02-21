
variable "business_division" {
  description = "The business division"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., development, staging, production)"
  type        = string
}
   
# AWS EC2 Instance Terraform Variables
# EC2 Instance Variables

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.micro"  
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type = string
  default = "eks-terraform-key"
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "public_subnets" {
  description = "Public Subnets"
  type = list(string)  
}