terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.10.40"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.5.0"
    }
  }
}
