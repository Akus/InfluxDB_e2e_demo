variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"  # Change this to your preferred region
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_helm_chart_version" {
  description = "Version of the ArgoCD Helm chart"
  type        = string
  default     = "5.27.1"  # Update to the latest version as needed
}