output "aws_account_id" {
  description = "ID of the AWS account where the tenant's DuploCloud portal runs."
  value       = data.duplocloud_aws_account.this.account_id
}

output "aws_region" {
  description = "AWS region where the tenant's resources will be deployed."
  value       = data.duplocloud_tenant_aws_region.this.aws_region
}
