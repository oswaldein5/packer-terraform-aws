#* Terraform configuration block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.47.0"
    }
  }
  required_version = "~>1.8.2"
}

#* AWS provider configuration block
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
}
