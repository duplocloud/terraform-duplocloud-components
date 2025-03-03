output "vpc" {
  description = "The VPC ID and name which is the default for this tenant."
  value = {
    name = local.infra.vpc_name
    id   = local.infra.vpc_id
  }
}

output "region" {
  description = "The region where the tenant is created."
  value       = local.infra.region
}
