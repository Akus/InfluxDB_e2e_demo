terraform {
  backend "s3" {
    bucket         = "akos-influx-eks-terraform-state-bucket"
    key            = "development/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
