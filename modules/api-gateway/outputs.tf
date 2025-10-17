output "id" {
  description = "The ID of the API Gateway"
  value       = local.api_id
}

output "arn" {
  description = "The ARN of the API Gateway"
  value = local.api.arn
}

output "domains" {
  description = "A list of all domains associated with this API Gateway"
  value = concat(
    [for mapping in aws_api_gateway_base_path_mapping.this : mapping.domain_name],
    [for mapping in aws_apigatewayv2_api_mapping.this : mapping.domain_name]
  )
}
