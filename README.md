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


## Terraform setup

### Create folder structure
terraform-infra\scripts\setup_terraform_folder_structure.ps1

### Download and install Terraform version
https://releases.hashicorp.com/terraform/1.6.0/

### Create S3 bucket for Terraform state files
akos-influx-eks-terraform-state-bucket

### Create DynamoDB table for Terraform state lock
table name: terraform-lock
partition key: LockID

### deploy networking module into the development environment
cd "E:\Documents\repos\InfluxDB_e2e_demo\terraform-infra\envs\development"
terraform init
terraform plan -out=tfplan
terraform apply "tfplan"

## Investigating dependency cycles

```powershell
terraform graph | Out-File -Encoding ASCII graph.dot
dot -Tpng graph.dot -o graph.png
```