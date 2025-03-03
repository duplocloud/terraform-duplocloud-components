locals {
  tenant_id = duplocloud_tenant.this.tenant_id
  infra     = data.duplocloud_infrastructure.this
}

data "duplocloud_infrastructure" "this" {
  infra_name = var.infra_name
}
