output "name" {
  description = "The name of the Lambda function"
  value       = duplocloud_aws_lambda_function.this.name
}

output "fullname" {
  description = "The full name of the Lambda function"
  value       = duplocloud_aws_lambda_function.this.fullname
}

output "arn" {
  description = "The ARN of the Lambda function"
  value       = duplocloud_aws_lambda_function.this.arn
}
