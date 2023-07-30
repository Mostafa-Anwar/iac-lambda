terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.5"
  }
}
backend "s3" {
bucket = "terraform-misc"
key = "terraform/terraform_lambda.tfstate"
region = "us-east-2"
encrypt = "true"
}
}
provider "aws" {
region = var.region
shared_credentials_files = ["~/.aws/credentials"]
profile = var.profile
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}