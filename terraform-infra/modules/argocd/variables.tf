variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
}

variable "argocd_helm_chart_version" {
  description = "Version of the ArgoCD Helm chart"
  type        = string
}