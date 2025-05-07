output "do_cert_lookup" {
  description = "Whether a certificate lookup is needed."
  value       = local.do_cert_lookup
}

# output "fqdn" {
#   description = "The FQDN for the lb"
#   value       = local.is_ingress ? duplocloud_k8_ingress.this[0].fqdn : null
# }
