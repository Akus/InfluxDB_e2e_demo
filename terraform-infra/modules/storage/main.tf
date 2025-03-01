
provider "aws" {
  region = var.region
}

# Kubernetes provider configuration using AWS EKS
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# resource "aws_eks_cluster" "eks" {
#   name     = var.cluster_name
#   role_arn = aws_iam_role.eks.arn

#   vpc_config {
#     subnet_ids = aws_subnet.eks[*].id
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy,
#   ]
# }

resource "aws_efs_file_system" "efs" {
  creation_token = "eks-efs"
}

resource "aws_efs_mount_target" "efs_mount_target" {

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.vpc_private_subnets[0]
  security_groups = [var.eks_node_group_security_group_id]
}

resource "aws_efs_mount_target" "efs_mount_target_2" {

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.vpc_private_subnets[1]
  security_groups = [var.eks_node_group_security_group_id]
}

resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "efs-sc"
  }

  storage_provisioner = "efs.csi.aws.com"

  mount_options = ["tls"]

  parameters = {
    provisioningMode  = "efs-ap"
    fileSystemId      = aws_efs_file_system.efs.id
    directoryPerms    = "755"
  }
}

resource "kubernetes_persistent_volume" "efs_pv" {
  metadata {
    name = "efs-pv"
  }

  spec {
    capacity = {
      storage = var.storage_size
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.efs.id
      }
    }

    storage_class_name = kubernetes_storage_class.efs.metadata[0].name
  }
}

# resource "kubernetes_persistent_volume_claim" "efs_pvc" {
#   metadata {
#     name = "efs-pvc"
#   }

#   spec {
#     access_modes = ["ReadWriteMany"]

#     resources {
#       requests = {
#         storage = var.storage_size
#       }
#     }

#     storage_class_name = kubernetes_storage_class.efs.metadata[0].name
#   }
# }