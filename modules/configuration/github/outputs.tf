output "id" {
  description = "The ID of the configuration. This is only used for the name of a volume mounted on a service."
  value       = var.name
}

output "name" {
  description = "The actual name of the configuration."
  value       = var.name
  sensitive   = false
}

output "type" {
  description = "The type configuration."
  value       = var.type
}

output "class" {
  description = "The class of the configuration."
  value       = var.class
}
