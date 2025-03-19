resource "duplocloud_infrastructure" "this" {
  infra_name         = coalesce(var.name, terraform.workspace)
  cloud              = local.clouds[var.cloud]
  region             = var.region
  enable_k8_cluster  = var.class == "k8s"
  enable_ecs_cluster = var.class == "ecs"
  address_prefix     = var.address_prefix
  azcount            = var.azcount
  subnet_cidr        = var.subnet_cidr
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
