terraform {
  required_version = ">= 1.4.4"
  backend "gcs" {
    prefix = "mywebsite"
  }
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.11.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.27.0"
    }
  }
}
provider "duplocloud" {
}

provider "google" {
  project = module.ctx.account_id
  region  = module.ctx.region
}

locals {
  tenant_name   = "tf-tests"
  bucket_prefix = "mywebsite"
}

module "ctx" {
  source = "../../modules/context"
  admin  = true
}

module "website" {
  source        = "../../modules/website-gcp"
  tenant_name   = local.tenant_name
  name          = "mysite"
  dns_zone_name = "myzone"
  sites = [
    {
      name     = "pmi-website"
      path     = "/pmi/*"
      bucket   = "pmi-bucket"
      priority = "1"
    },
    {
      name     = duplocloud_gcp_storage_bucket_v2.auth_ui.fullname
      path     = "/auth/*"
      bucket   = duplocloud_gcp_storage_bucket_v2.auth_ui.fullname
      priority = "2"
    },
    {
      name     = duplocloud_gcp_storage_bucket_v2.pmm_ui.fullname
      path     = "/pmm/*"
      bucket   = duplocloud_gcp_storage_bucket_v2.pmm_ui.fullname
      priority = "3"
    }
  ]
}
