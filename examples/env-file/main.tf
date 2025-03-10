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

module "env" {
  source      = "../../modules/env-file"
  content = <<EOF
FOO=baz
MESSAGE="Hello, world!"
export buz=wuz
EOF
}

output "config" {
  value = module.env
}
