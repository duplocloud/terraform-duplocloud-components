output "services" {
  value = local.services
}
output "config" {
  value = local.compose.configs
}
output "secrets" {
  value = local.secrets
}
