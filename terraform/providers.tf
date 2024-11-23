terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Development"
      DeployedBy  = "Terraform"
      CodeRepo    = "aws-master-pipeline"
    }
  }

}
