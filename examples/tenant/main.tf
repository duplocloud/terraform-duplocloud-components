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
  #   key                  = "micro-service"
  #   encrypt              = true
  # }
}
provider "duplocloud" {}

module "tenant" {
  source     = "../../modules/tenant"
  infra_name = "oteltest"
  name       = "myapp"
  settings = {
    enable_host_other_tenants = "true"
  }
  configurations = [{
    description = "A shared configuration for all services in this tenant."
    data = {
      SHARED = "something"
    }
  }]
}
