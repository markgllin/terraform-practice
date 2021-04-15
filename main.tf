terraform {
  required_version = "= 0.14.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "remote" {
    organization = "marklin"

    workspaces {
      name = "gh-actions-tf-deploy"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}
