locals {
  tenant_id = data.duplocloud_tenant.this.id
}

data "duplocloud_tenant" "this" {
  name = var.tenant
}

# data "duplocloud_infrastructure" "this" {
#   tenant_id = local.tenant_id
# }
