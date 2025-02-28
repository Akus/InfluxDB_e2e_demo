# Security Group for EKS Node Group - Placeholder file
resource "aws_security_group" "eks_node_group" {
    name        = "${var.cluster_name}-eks-node-group-sg"
    description = "Security group for EKS Node Group"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS traffic"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic"
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow ArgoCD traffic"
    }

    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow Grafana traffic"
    }

    ingress {
        from_port   = 9090
        to_port     = 9090
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow Prometheus traffic"
    }

    ingress {
        from_port   = 8125
        to_port     = 8125
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow Telegraf traffic"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }

    tags = {
        Name = "${var.cluster_name}-eks-node-group-sg"
    }
}