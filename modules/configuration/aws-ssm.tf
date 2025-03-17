resource "duplocloud_aws_ssm_parameter" "managed" {
  count       = var.managed && local.is_ssm ? 1 : 0
  tenant_id   = var.tenant_id
  name        = local.name
  description = var.description
  type        = local.schema.type
  value       = local.value
}

resource "duplocloud_aws_ssm_parameter" "unmanaged" {
  count       = !var.managed && local.is_ssm ? 1 : 0
  tenant_id   = var.tenant_id
  name        = local.name
  description = var.description
  type        = local.schema.type
  value       = local.value
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
