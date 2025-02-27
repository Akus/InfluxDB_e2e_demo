terraform {
  backend "s3" {
    bucket         = "akos-influx-eks-terraform-state-bucket-production"
    key            = "production/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "production/terraform-lock"
    encrypt        = true
  }
}