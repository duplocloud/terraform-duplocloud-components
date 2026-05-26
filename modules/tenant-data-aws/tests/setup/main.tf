terraform {
  required_version = "~> 1.12.2"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "~> 0.11.30"
    }
  }
}

provider "duplocloud" {}

variable "tenant_name" {
  type = string
}

data "duplocloud_admin_aws_credentials" "this" {}

data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

data "duplocloud_tenant_aws_region" "this" {
  tenant_id = data.duplocloud_tenant.this.id
}

output "credentials" {
  sensitive = true
  value     = data.duplocloud_admin_aws_credentials.this
}

output "region" {
  value = data.duplocloud_tenant_aws_region.this.aws_region
}
