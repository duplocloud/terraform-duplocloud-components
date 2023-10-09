terraform {
  required_version = ">= 1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "> 0.9.40"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "duplocloud" {

}

variable "tenant_id" {
  type = string
}

module "asg" {
  source             = "../../modules/eks-nodes"
  # version            = "0.0.10"
  tenant_id = var.tenant_id
  prefix = "fun-"
  instance_count = 1
  min_instance_count = 1
  max_instance_count = 1
  capacity = "m5.large"
  os_disk_size = 20
  eks_version = "1.24"
}
