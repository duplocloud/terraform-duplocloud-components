output "vpc" {
  description = "The VPC ID and name which is the default for this tenant."
  value = module.tenant.vpc
}

output "region" {
  description = "The region where the tenant is created."
  value       = module.tenant.region
}
