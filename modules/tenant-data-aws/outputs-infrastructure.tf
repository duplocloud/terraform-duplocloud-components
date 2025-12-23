output "availability_zones" {
  description = "Availability zones in the tenant's infrastructure."
  value       = data.duplocloud_plan.this.availability_zones
}

output "infrastructure_name" {
  description = "Name of the tenant's infrastructure."
  value       = data.duplocloud_infrastructure.this.infra_name
}

output "plan_id" {
  description = "Name of the plan linked to the tenant's infrastructure."
  value       = data.duplocloud_plan.this.plan_id
}
