# variables.tf - Input variables for the module

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "bastion"
}

variable "vpc_id" {
  description = "ID of the VPC where the bastion host will be deployed"
  type        = string
}

variable "public_subnets" {
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the bastion host"
  type        = string
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to the bastion via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "additional_user_data" {
  description = "Additional user data script content"
  type        = string
  default     = ""
}

variable "create_iam_role" {
  description = "Whether to create an IAM role for the bastion host"
  type        = bool
  default     = true
}

variable "existing_iam_instance_profile" {
  description = "Name of an existing IAM instance profile to use (if create_iam_role is false)"
  type        = string
  default     = ""
}

variable "enable_ssm" {
  description = "Whether to enable AWS Systems Manager for the bastion"
  type        = bool
  default     = true
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the bastion host"
  type        = bool
  default     = true
}