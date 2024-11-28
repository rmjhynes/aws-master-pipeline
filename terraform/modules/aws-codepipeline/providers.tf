terraform {
  //  backend "s3" {
  //    bucket = "terraform-state-126781719022"
  //    region = "us-east-1"
  //  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.9.6"
}
