output "dns_domain" {
  description = "External DNS domain of the tenant's infrastructure with no leading or trailing period."
  value       = local.dns_domain
}

output "dns_zone_id" {
  description = "ID of the Route53 hosted zone of dns_domain."
  value       = one(data.duplocloud_plan_settings.this.dns_setting).domain_id
}
