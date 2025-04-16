output "id" {
  description = "The tenants id."
  value       = module.tenant.id
}

output "name" {
  description = "The tenants name."
  value       = module.tenant.name
}

output "infra_name" {
  description = "The tenants infra_name."
  value       = module.tenant.infra_name
}

output "configurations" {
  value       = module.tenant.configurations
  description = "The configurations for the tenant."
}
