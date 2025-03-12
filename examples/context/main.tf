terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.90.1"
    }
  }
}
provider "duplocloud" {}

provider "aws" {
  region     = module.ctx.creds.aws.region
  access_key = module.ctx.creds.aws.access_key_id
  secret_key = module.ctx.creds.aws.secret_access_key
  token      = module.ctx.creds.aws.session_token
}

provider "kubernetes" {
  host                   = module.ctx.creds.k8s.endpoint
  cluster_ca_certificate = module.ctx.creds.k8s.ca_certificate_data
  token                  = module.ctx.creds.k8s.token
}

variable "tenant" {
  type    = string
  default = "tf-tests"
}

module "ctx" {
  source = "../../modules/context"
  tenant = var.tenant
  jit = {
    aws = true
    k8s = true
  }
}

# output "ctx" {
#   value = module.ctx
# }
