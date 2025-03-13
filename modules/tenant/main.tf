locals {
  tenant_id = duplocloud_tenant.this.tenant_id
  parent    = var.parent != null ? data.duplocloud_tenant.parent[0] : null
  infra_name = coalesce(
    var.infra_name,
    var.parent != null ? local.parent.plan_id : "default"
  )
}

data "duplocloud_tenant" "parent" {
  count = var.parent != null ? 1 : 0
  name  = var.parent
}
