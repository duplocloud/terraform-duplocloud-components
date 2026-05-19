locals {
  # data.duplocloud_plan.this.certificates returns null when there are no certificates in the plan.
  default_certificate_enabled = data.duplocloud_plan.this.certificates == null ? false : anytrue([
    for cert in data.duplocloud_plan.this.certificates :
    startswith(cert.name, "duplo-default/")
  ])
}

output "default_certificate_arn" {
  description = "ARN of the `duplo-default/.domain.example.com` ACM certificate created automatically by the DuploCloud portal (if it exists)."
  value       = local.default_certificate_enabled ? one(data.duplocloud_plan_certificate.default).arn : null
}

output "default_certificate_name" {
  description = "Name of the `duplo-default/.domain.example.com` ACM certificate created automatically by the DuploCloud portal (if it exists)."
  value       = local.default_certificate_enabled ? one(data.duplocloud_plan_certificate.default).name : null
}
