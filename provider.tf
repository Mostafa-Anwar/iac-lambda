terraform {
  required_version = "1.4.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Lock version to prevent unexpected problems
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
