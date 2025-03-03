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

variable "tenant" {
  description = "The tenant to deploy the service to."
  default     = "tf-tests"
  type        = string
}

module "loadbalancer" {
  source = "../../modules/loadbalancer"
  name   = "mylb"
  tenant = var.tenant
  class  = "standalone-alb"
}
