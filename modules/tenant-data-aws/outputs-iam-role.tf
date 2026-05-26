output "iam_role_arn" {
  description = "ARN of the tenant's IAM role."
  value       = data.aws_iam_role.this.arn
}

output "iam_role_name" {
  description = "Name of the tenant's IAM role."
  value       = data.aws_iam_role.this.name
}
