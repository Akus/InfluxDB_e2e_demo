resource "aws_security_group" "efs" {
  name        = "${var.cluster_name} efs"
  description = "Allow traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "TCP"
    cidr_blocks      = [var.vpc_cidr_block]
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "eks-efs"
}

resource "aws_efs_mount_target" "efs_mount_target" {

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.vpc_private_subnets[0]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "efs_mount_target_2" {

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.vpc_private_subnets[1]
  security_groups = [aws_security_group.efs.id]
}

data "aws_eks_cluster" "cluster" {
  depends_on = [ aws_eks_cluster.eks_cluster ]
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "efs-sc"
  }

  storage_provisioner = "efs.csi.aws.com"

  # mount_options = ["tls"]

  parameters = {
    provisioningMode  = "efs-ap"
    fileSystemId      = aws_efs_file_system.efs.id
    directoryPerms    = "700"
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

resource "kubernetes_persistent_volume" "efs_pv_2" {
  metadata {
    name = "efs-pv-2"
  }

  spec {
    capacity = {
      storage = 10
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

resource "kubernetes_persistent_volume" "efs_pv_3" {
  metadata {
    name = "efs-pv-3"
  }

  spec {
    capacity = {
      storage = 5
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

resource "kubernetes_persistent_volume" "efs_pv_4" {
  metadata {
    name = "efs-pv-4"
  }

  spec {
    capacity = {
      storage = 10
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

# # dummy claim pvc
# resource "kubernetes_persistent_volume_claim" "efs_pvc" {
#   metadata {
#     name = "efs-pvc-2"
#     namespace = "influxdb"
#   }

#   spec {
#     access_modes = ["ReadWriteMany"]
#     storage_class_name = kubernetes_storage_class.efs.metadata[0].name
#     resources {
#       requests = {
#         storage = 10
#       }
#     }
#   }
# }



# module "vpc_cni_irsa" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.0"

#   role_name_prefix                   = "VPC-CNI-IRSA"
#   attach_vpc_cni_policy              = true
#   vpc_cni_enable_ipv4                = true
#   attach_ebs_csi_policy              = true

#   oidc_providers = {
#     efs = {
#       provider_arn               = module.efs.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
#     }
#   }
# }

