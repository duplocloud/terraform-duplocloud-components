output "tenant_id" {
  description = "ID of the tenant."
  value       = data.duplocloud_tenant.this.id
}
