output "kms_key_arn" {
  description = "ARN of the tenant's KMS key."
  value       = data.duplocloud_tenant_aws_kms_key.this.key_arn
}

output "kms_key_id" {
  description = "ID of the tenant's KMS key."
  value       = data.duplocloud_tenant_aws_kms_key.this.key_id
}
