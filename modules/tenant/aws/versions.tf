terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.10.40"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.90.1"
    }
  }
}
