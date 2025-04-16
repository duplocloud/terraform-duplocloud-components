terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.10.0"
    }
  }
  # backend "s3" {
  #   workspace_key_prefix = "duplocloud/components"
  #   key                  = "micro-service"
  #   encrypt              = true
  # }
}
provider "duplocloud" {}

module "infra" {
  source         = "../../modules/infrastructure"
  name           = "nonprod01"
  class          = "k8s"
  address_prefix = "11.221.0.0/16"
  settings = {
    EnableAwsAlbIngress     = "true"
    EnableClusterAutoscaler = "true"
    EnableSecretCsiDriver   = "true"
  }
  metadata = {
    foo = "bar"
  }
}

output "infra" {
  value = module.infra
}

output "mask" {
  value = cidrhost(module.infra.address_prefix, -1)
}
