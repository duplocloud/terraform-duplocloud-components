
output "configurations" {
  value       = module.configurations
  description = "The configurations object."
}

output "release_id" {
  value       = local.release_id
  description = "The random release id for this deployment."
}

output "volumes" {
  value       = local.volumes
  description = "The list of volumes mounted to the service."
}
