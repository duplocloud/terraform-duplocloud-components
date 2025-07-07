output "id" {
  description = "The ID of the configuration. This is only used for the name of a volume mounted on a service."
  value       = local.id
}

output "name" {
  description = "The actual name of the configuration."
  value       = nonsensitive(local.realName)
  sensitive   = false
}

output "description" {
  description = "The description of the configuration."
  value       = var.description
}

output "type" {
  description = "The type configuration."
  value       = var.type
}

output "csi" {
  description = "Whether or not the configuration is a CSI configuration. This may be different than the input because some classes don't support CSI."
  value       = local.csi
}

output "enabled" {
  description = "Whether or not the configuration is enabled."
  value       = var.enabled
}

output "class" {
  description = "The class of the configuration."
  value       = var.class
}

output "env" {
  description = "The env var list if the configuration either remapped any key or is a reference type where the config name is a value of an environment variable."
  value       = length(local.env) > 0 ? local.env : null
}

output "envFrom" {
  description = "The envFrom configuration if the configuration is of type environment and enabled."
  value       = length(local.envFrom) > 0 ? local.envFrom[0] : null
}

output "volume" {
  description = "The volume configuration if the configuration is of type files and enabled. Even when type is environment, if csi is enabled then a volume is also needed."
  # for each of the key values in local.volumes, if the value is not null, then return the value
  value     = length(local.volume) > 0 ? local.volume[0] : null
  sensitive = false
}

output "volumeMounts" {
  description = "The volume mount configuration if the configuration is of type files and enabled. Even when type is environment, if csi is enabled then a volume mount is also needed."
  value       = local.volumeMounts
}
