provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "iac-demo-bucket"
    key    = "aws/ecr/nginx-app/terraform.tfstate"
    region = "ap-southeast-1"
  }
}