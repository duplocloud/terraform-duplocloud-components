output "name" {
  value = var.name
}
output "owner" {
  value = var.owner
}
output "description" {
  value = var.description
}
output "class" {
  value = var.class
}
output "cloud" {
  value = var.cloud
}
output "visibility" {
  value = var.visibility
}
output "mode" {
  value = var.mode
}
output "properties" {
  description = "The custom properties applied to this repo."
  value       = local.props
}
output "repo" {
  description = "The repo object from the provider."
  value       = local.repo
}

output "active_workflows" {
  value = local.active_workflows
}
