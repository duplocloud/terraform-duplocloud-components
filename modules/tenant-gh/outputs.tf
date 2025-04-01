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

output "envFrom" {
  description = "The envFrom for the embedded configurations ready for some services to use."
  value       = module.tenant.envFrom
}

output "volumeMounts" {
  description = "The volumeMounts for the embedded configurations ready for some services to use."
  value       = module.tenant.volumeMounts
}

output "volumes" {
  description = "The volumes for the embedded configurations ready for some services to use."
  value       = module.tenant.volumes
}
