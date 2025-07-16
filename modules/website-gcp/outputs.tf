output "name" {
  description = "Name of the website"
  value       = var.name
}

output "url" {
  description = "The full URL to the website."
  value       = local.url
}
