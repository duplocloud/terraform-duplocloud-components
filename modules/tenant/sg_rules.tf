resource "duplocloud_tenant_network_security_rule" "this" {
  for_each = {
    for rule in var.sg_rules : "${rule.type}-${rule.to_port}-${rule.protocol}" => {
      to_port        = rule.to_port
      from_port      = coalesce(rule.from_port, rule.to_port)
      protocol       = rule.protocol
      tenant_id      = rule.type == "egress" ? local.parent.id : local.tenant_id
      source_tenant  = rule.type == "egress" ? var.name : rule.source_tenant
      source_address = rule.source_address
      description = coalesce(
        rule.description,
        "${rule.type} for ${var.name} for port ${rule.to_port}"
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
