### InfluxDB e2e demo setup

## Terraform infra
terraform-infra/
│── modules/                 # Reusable Terraform modules
│   ├── networking/          # VPC, subnets, security groups, etc.
│   ├── compute/             # EC2, ECS, EKS, etc.
│   ├── storage/             # S3, RDS, EFS, etc.
│   ├── monitoring/          # CloudWatch, Prometheus, etc.
│── envs/                    # Environment-specific configurations
│   ├── development/         
│   │   ├── main.tf          # Calls modules with dev-specific variables
│   │   ├── variables.tf     # Defines environment-specific variables
│   │   ├── backend.tf       # Remote state configuration
│   │   ├── outputs.tf       # Outputs for reference
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── backend.tf
│   │   ├── outputs.tf
│   ├── production/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── backend.tf
│   │   ├── outputs.tf
│── global/                  # Shared configurations across all environments
│   ├── providers.tf         # Provider configurations (AWS, GCP, etc.)
│   ├── versions.tf          # Terraform version constraints
│── terraform.tfvars         # Global variables (optional)
│── README.md                # Documentation