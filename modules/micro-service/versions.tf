terraform {
  required_version = ">= 1.9.0"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}
