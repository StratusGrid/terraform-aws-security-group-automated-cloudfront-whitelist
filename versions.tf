terraform {
  required_version = "~> 1.1"

  required_providers {
    archive = ">= 1.3"
    null    = ">= 2.1"
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
  }
}