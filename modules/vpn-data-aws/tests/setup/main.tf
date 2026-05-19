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

data "duplocloud_admin_aws_credentials" "this" {}

output "credentials" {
  sensitive = true
  value     = data.duplocloud_admin_aws_credentials.this
}
