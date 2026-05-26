output "nat_ips" {
  description = "NAT gateway IPs. These IPs are the source addresses for any external firewalls to allow access from the tenant's workload."
  value       = data.duplocloud_infrastructure.this.nat_ips
}

output "private_subnet_ids" {
  description = "List of the IDs of the private subnets in the tenant's infrastructure."
  value       = [for s in data.duplocloud_infrastructure.this.private_subnets : s.id]
}

output "public_subnet_ids" {
  description = "List of the IDs of the public subnets in the tenant's infrastructure."
  value       = [for s in data.duplocloud_infrastructure.this.public_subnets : s.id]
}

output "vpc_id" {
  description = "ID of the VPC managed by the tenant's infrastructure."
  value       = data.duplocloud_infrastructure.this.vpc_id
}
