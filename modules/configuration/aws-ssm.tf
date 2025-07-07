resource "duplocloud_aws_ssm_parameter" "managed" {
  count = (
    local.is_ssm &&
    var.managed &&
    !var.external
  ) ? 1 : 0
  tenant_id   = var.tenant_id
  name        = local.name
  description = var.description
  type        = local.schema.type
  value       = local.value
}

resource "duplocloud_aws_ssm_parameter" "unmanaged" {
  count = (
    local.is_ssm &&
    !var.managed &&
    !var.external
  ) ? 1 : 0
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
