terraform {
  required_version = ">= 1.4.4"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
