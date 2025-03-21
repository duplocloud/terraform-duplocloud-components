resource "duplocloud_tenant_network_security_rule" "this" {
  for_each = {
    for rule in var.security_rules : "${coalesce(rule.source_tenant, rule.source_address, "parent")}-${rule.to_port}-${rule.protocol}" => {
      to_port        = rule.to_port
      from_port      = coalesce(rule.from_port, rule.to_port)
      protocol       = rule.protocol
      source_address = rule.source_address
      tenant_id = (
        rule.source_tenant == null &&
        rule.source_address == null
      ) ? local.parent.id : local.tenant_id
      source_tenant = (
        rule.source_tenant == null &&
        rule.source_address == null
      ) ? local.name : rule.source_tenant
      description = coalesce(
        rule.description,
        (
          rule.source_tenant == null &&
          rule.source_address == null
        ) ? "${local.name} to port ${rule.to_port}" : "${coalesce(rule.source_tenant, rule.source_address)} to port ${rule.to_port}"
      )
    }
  }
  tenant_id      = each.value.tenant_id
  source_tenant  = each.value.source_tenant
  source_address = each.value.source_address
  protocol       = each.value.protocol
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  description    = each.value.description
}
