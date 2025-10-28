## this helps to move a tenant module to another
module "tenant" {
  # source  = "duplocloud/components/duplocloud//modules/tenant"
  source  = "duplocloud/components/duplocloud//modules/tenant-gh"
  version = "0.0.41"
}

moved {
  from = module.tenant.duplocloud_tenant.this
  to   = module.tenant.module.tenant.duplocloud_tenant.this
}

moved {
  from = module.tenant.duplocloud_tenant_config.this
  to   = module.tenant.module.tenant.duplocloud_tenant_config.this
}