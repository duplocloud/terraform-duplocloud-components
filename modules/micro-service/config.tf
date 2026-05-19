module "configurations" {
  for_each = {
    for idx, config in var.configurations : (
      config.name != null ? "${config.class}/${config.name}" : config.type == "environment" ? "${config.class}/env" : "${config.class}/config"
    ) => config
  }
  source      = "../configuration"
  tenant_id   = local.tenant.id
  prefix      = var.name # uses app name as prefix
  name        = each.value.name
  enabled     = each.value.enabled
  description = each.value.description
  type        = each.value.type
  class       = each.value.class
  csi         = each.value.csi
  managed     = each.value.managed
  external    = each.value.external
  mountPath   = each.value.mountPath
  data        = each.value.external ? null : each.value.data
  value       = each.value.value
}
