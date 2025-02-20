variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "business_division" {
  description = "Business division"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., development, staging, production)"
  type        = string
}