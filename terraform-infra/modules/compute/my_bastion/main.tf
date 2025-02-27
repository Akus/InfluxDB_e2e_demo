# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name_prefix}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  # SSH access from allowed CIDR blocks
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
    description = "SSH access"
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion-sg"
    }
  )
}

# Bastion host EC2 instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = var.public_subnets[0]
  iam_instance_profile   = var.create_iam_role ? aws_iam_instance_profile.bastion_profile[0].name : var.existing_iam_instance_profile

  user_data = <<-EOF
    #!/bin/bash
    echo "Bastion host setup..."
    yum update -y
    ${var.additional_user_data}
  EOF

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion"
    }
  )
}

# IAM role and instance profile (optional)
resource "aws_iam_role" "bastion_role" {
  count = var.create_iam_role ? 1 : 0
  
  name = "${var.name_prefix}-bastion-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_instance_profile" "bastion_profile" {
  count = var.create_iam_role ? 1 : 0
  
  name = "${var.name_prefix}-bastion-profile"
  role = aws_iam_role.bastion_role[0].name
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  count = var.create_iam_role && var.enable_ssm ? 1 : 0
  
  role       = aws_iam_role.bastion_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create Elastic IP for bastion host (optional)
resource "aws_eip" "bastion" {
  count    = var.create_eip ? 1 : 0
  instance = aws_instance.bastion.id
  domain   = "vpc"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion-eip"
    }
  )
}