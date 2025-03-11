terraform {
  required_version = ">= 1.4.4"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}

provider "github" {
  owner = "duplocloud"
  app_auth {}
}

module "config" {
  source     = "../../modules/configuration/github"
  repository = "terraform-duplocloud-components"
  class      = "gh-secret"
  tenant     = "salesdemo"
  name       = "MY_VAR"
  value      = "hello"
}
