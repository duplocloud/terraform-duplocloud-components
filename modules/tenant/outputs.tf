output "id" {
  description = "The tenants id."
  value       = local.tenant_id
}

output "name" {
  description = "The tenants name."
  value       = var.name
}

output "infra_name" {
  description = "The tenants infra_name."
  value       = local.infra_name
}
