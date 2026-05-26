output "tenant_id" {
  description = "ID of the tenant."
  value       = data.duplocloud_tenant.this.id
}

output "tenant_name" {
  description = "Name of the tenant."
  value       = data.duplocloud_tenant.this.name
}
