output "id" {
  description = "The tenants id."
  value       = local.tenant_id
}

output "name" {
  description = "The tenants name."
  value       = local.name
}

output "namespace" {
  description = "The namespace within kubernetes this tenant is in."
  value       = "duploservices-${local.name}"
}

output "infra_name" {
  description = "The tenants infra_name."
  value       = local.infra_name
}

output "configurations" {
  value       = module.configurations
  description = "The configurations for the tenant."
}
