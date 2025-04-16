resource "duplocloud_infrastructure" "this" {
  infra_name               = coalesce(var.name, terraform.workspace)
  cloud                    = local.clouds[local.cloud]
  account_id               = var.account
  region                   = var.region
  enable_k8_cluster        = local.classdef.has_k8s
  enable_ecs_cluster       = local.classdef.has_ecs
  is_serverless_kubernetes = local.classdef.has_autopilot
  address_prefix           = local.address_prefix
  azcount                  = var.azcount
  subnet_cidr              = var.subnet_cidr
  lifecycle {
    ignore_changes = [
      # don't try and recreate because any of these changed
      # especialy address_prefix because it might be null and the 
      address_prefix,
      cloud
    ]
  }
}

resource "duplocloud_infrastructure_setting" "this" {
  count      = var.settings != null ? 1 : 0
  infra_name = local.name
  dynamic "setting" {
    for_each = var.settings
    content {
      key   = setting.key
      value = setting.value
    }
  }
}

resource "duplocloud_infrastructure_subnet" "this" {
  for_each   = var.subnets
  name       = each.key
  infra_name = local.name
  cidr_block = each.value.cidr_block
  zone       = each.value.zone
  type       = each.value.type
}
