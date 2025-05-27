terraform {
  required_version = ">= 1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.19.0"
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.11.8"
    }
  }
  backend "s3" {
    workspace_key_prefix = "duplocloud/components"
    key                  = "eks-nodes"
    encrypt              = true
  }
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
  default     = "tf-tests"
}

provider "aws" {
  region = "us-west-2"
}

provider "duplocloud" {

}

data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

module "asg" {
  source = "../../modules/eks-nodes"
  # version            = "0.0.10"
  tenant_id          = data.duplocloud_tenant.this.id
  prefix             = "fun"
  instance_count     = 1
  min_instance_count = 1
  max_instance_count = 1
  capacity           = "m5.large"
  os_disk_size       = 20
  eks_version        = "1.30"
}
