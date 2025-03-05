resource "duplocloud_tenant" "this" {
  account_name   = var.name
  plan_id        = var.infra_name
  allow_deletion = false
}

resource "duplocloud_tenant_config" "this" {
  tenant_id = local.tenant_id
  dynamic "setting" {
    for_each = var.settings
    content {
      key   = setting.key
      value = setting.value
    }
  }
}
