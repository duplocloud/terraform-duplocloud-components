terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "0.11.1"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
  backend "s3" {
    workspace_key_prefix = "duplocloud/components"
    key                  = "tenant-gh"
    encrypt              = true
  }
}
provider "duplocloud" {}

provider "github" {
  owner = "duplocloud"
  # app_auth {}
}

variable "infra_name" {
  description = "The name of the infrastructure to place the tenant in."
  type        = string
  default     = "oteltest"
}

module "ctx" {
  source = "../../modules/context"
  infra  = var.infra_name
  admin  = true
  jit = {
    aws = true
  }
}

module "tenant" {
  source     = "../../modules/tenant-gh"
  infra_name = var.infra_name
  name       = terraform.workspace
  repos = [
    "terraform-duplocloud-components"
  ]
  settings = {
    enable_service_on_any_host = "true"
  }
  configurations = [{
    description = "A shared configuration for all services in this tenant."
    data = {
      SHARED = "something"
    }
  }]
}
