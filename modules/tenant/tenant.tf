resource "duplocloud_tenant" "this" {
  account_name   = local.name
  plan_id        = local.infra_name
  allow_deletion = var.allow_deletion
  lifecycle {
    ignore_changes = [
      account_name,
      plan_id
    ]
  }
}

resource "duplocloud_tenant_config" "this" {
  count     = var.settings != null ? 1 : 0
  tenant_id = local.tenant_id
  dynamic "setting" {
    for_each = var.settings
    content {
      key   = setting.key
      value = setting.value
    }
  }
}
