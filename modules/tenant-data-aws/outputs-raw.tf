output "raw" {
  description = "Raw data. Use these if no other output has what you need."

  value = {
    "iam_role"            = data.aws_iam_role.this
    "infrastructure"      = data.duplocloud_infrastructure.this
    "default_certificate" = local.default_certificate_enabled ? one(data.duplocloud_plan_certificate.default) : null
    "eks_cluster"         = data.duplocloud_infrastructure.this.enable_k8_cluster ? one(data.aws_eks_cluster.this) : null
    "kms_key"             = data.duplocloud_tenant_aws_kms_key.this
    "plan_settings"       = data.duplocloud_plan_settings.this
    "plan"                = data.duplocloud_plan.this
    "security_group"      = data.aws_security_group.this
    "tenant"              = data.duplocloud_tenant.this
  }
}
