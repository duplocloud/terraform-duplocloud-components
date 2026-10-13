terraform {
  required_version = ">= 1.4.4"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
  # backend "s3" {
  #   workspace_key_prefix = "duplocloud/components"
  #   key                  = "project"
  #   encrypt              = true
  # }
}

locals {
  owner = "duplocloud"
}

provider "github" {
  owner = local.owner
  app_auth {}
}
module "project" {
  source      = "../../modules/project-gh"
  name        = "terraform-duplocloud-components"
  owner       = local.owner
  class       = "library"
  mode        = "data"
  description = "Shared TF modules with common patterns using the Duplocloud TF provider."
}

output "project" {
  value = module.project
}
