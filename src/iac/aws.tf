#
# basic terraform setup
#
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
      }
    }

    required_version = ">= 1.2.0"
}

#
# select AWS as our provider
# fixed to us-west-1 (for isolation)
#
provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
    # access_key = ""
    # secret_key = ""
}