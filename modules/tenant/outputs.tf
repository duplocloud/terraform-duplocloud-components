output "id" {
  description = "The tenants id."
  value       = local.tenant_id
}

output "name" {
  description = "The tenants name."
  value       = local.name
}

output "infra_name" {
  description = "The tenants infra_name."
  value       = local.infra_name
}

output "envFrom" {
  description = "The envFrom for the embedded configurations ready for some services to use."
  value = [
    for config in module.configurations : config.envFrom
    if config.envFrom != null
  ]
}

output "volumeMounts" {
  description = "The volumeMounts for the embedded configurations ready for some services to use."
  value = [
    for config in module.configurations : config.volumeMount
    if config.volumeMount != null
  ]
}

output "volumes" {
  description = "The volumes for the embedded configurations ready for some services to use."
  value = [
    for config in module.configurations : config.volume
    if config.volume != null
  ]
}
