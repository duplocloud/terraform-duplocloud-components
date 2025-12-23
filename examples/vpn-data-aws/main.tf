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

# This example assumes that the portal you're getting credentials from has the VPN enabled in the
# portal's default region.
provider "aws" {
  access_key = data.duplocloud_admin_aws_credentials.current.access_key_id
  region     = data.duplocloud_admin_aws_credentials.current.region
  secret_key = data.duplocloud_admin_aws_credentials.current.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.current.session_token
}

module "vpn_data_aws" {
  source = "../../modules/vpn-data-aws"
}

output "vpn_data_aws" {
  value = module.vpn_data_aws
}
