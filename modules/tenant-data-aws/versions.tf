terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.26.0"
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.11.27"
    }
  }
}
