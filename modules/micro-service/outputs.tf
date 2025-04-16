output "name" {
  description = "The name of the service."
  value       = local.service.name
}
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

output "namespace" {
  description = "The namespace within kubernetes this service is in."
  value       = local.namespace
}

output "domain" {
  description = "The fully qualified domain name of the service."
  value       = local.service.domain
}

output "parent_domain" {
  description = "The parent domain of the service."
  value       = local.service.parent_domain
}

output "image" {
  description = "The actual image in use atm."
  value       = local.service.docker_image
}

## leave this commented out, it's useful when deciding what to output
# output "service" {
#   description = "The output of the service from the provider."
#   value       = local.service
# }
