terraform {
  required_version = "~> 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26.0"
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "~> 0.11.30"
    }
  }
}

provider "duplocloud" {}

data "duplocloud_admin_aws_credentials" "current" {}

data "duplocloud_tenant" "this" {
  name = "default"
}

data "duplocloud_tenant_aws_region" "this" {
  tenant_id = data.duplocloud_tenant.this.id
}

provider "aws" {
  access_key = data.duplocloud_admin_aws_credentials.current.access_key_id
  region     = data.duplocloud_tenant_aws_region.this.aws_region
  secret_key = data.duplocloud_admin_aws_credentials.current.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.current.session_token
}

module "tenant_data_aws" {
  source      = "../../modules/tenant-data-aws"
  tenant_name = data.duplocloud_tenant.this.name
}

output "tenant_data_aws" {
  value = module.tenant_data_aws
}
