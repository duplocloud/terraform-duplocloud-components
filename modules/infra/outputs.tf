output "name" {
  description = "The name of the infrastructure."
  value       = local.name
}

output "metadata" {
  description = "All of the metadata values on this plan."
  value = {
    for meta in duplocloud_plan_settings.this.all_metadata : meta.key => meta.value
  }
}

output "settings" {
  description = "All of the settings values on this plan."
  value = merge(var.settings, {
    for setting in duplocloud_infrastructure.this.all_settings : setting.key => setting.value
  })
}

output "vpc" {
  description = "The vpc configuration for this infrastructure."
  value = {
    id              = duplocloud_infrastructure.this.vpc_id
    name            = duplocloud_infrastructure.this.vpc_name
    security_groups = duplocloud_infrastructure.this.security_groups
    private_subnets = duplocloud_infrastructure.this.private_subnets
    public_subnets  = duplocloud_infrastructure.this.public_subnets
  }
}

output "status" {
  description = "The status of the infrastructure."
  value       = duplocloud_infrastructure.this.status
}
