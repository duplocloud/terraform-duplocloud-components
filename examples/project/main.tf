terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.9.40"
    }
  }
  # backend "s3" {
  #   workspace_key_prefix = "duplocloud/components"
  #   key                  = "project"
  #   encrypt              = true
  # }
}
provider "duplocloud" {}

module "project" {
  source = "../../modules/project"
  name   = "myapp"
}
