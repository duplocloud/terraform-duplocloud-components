output "default_certificate_arn" {
  description = "ARN of the `duplo-default/.domain.example.com` ACM certificate created automatically by the DuploCloud portal."
  value       = var.default_certificate_enabled ? one(data.duplocloud_plan_certificate.default).arn : null
}
