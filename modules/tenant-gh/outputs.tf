output "id" {
  description = "The tenants id."
  value       = module.tenant.id
}

output "name" {
  description = "The tenants name."
  value       = module.tenant.name
}

output "namespace" {
  description = "The namespace within kubernetes this tenant is in."
  value       = module.tenant.namespace
}

output "infra_name" {
  description = "The tenants infra_name."
  value       = module.tenant.infra_name
}

output "configurations" {
  value       = module.tenant.configurations
  description = "The configurations for the tenant."
}
