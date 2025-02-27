terraform {
  backend "s3" {
    bucket         = "akos-influx-eks-terraform-state-bucket-staging"
    key            = "development/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "staging/terraform-lock"
    encrypt        = true
  }
}