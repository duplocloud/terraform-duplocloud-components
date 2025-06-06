resource "duplocloud_tenant_secret" "managed" {
  count       = var.managed && var.class == "aws-secret" ? 1 : 0
  tenant_id   = var.tenant_id
  name_suffix = local.name
  data        = local.value
}

resource "duplocloud_tenant_secret" "unmanaged" {
  count       = !var.managed && var.class == "aws-secret" ? 1 : 0
  tenant_id   = var.tenant_id
  name_suffix = local.name
  data        = local.value
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}
