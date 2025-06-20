resource "duplocloud_aws_lambda_permission" "permission" {
  for_each = {
    for index, integration in local.integrations :
    "${integration.path}/${integration.method}/${integration.name}-${index}" => merge(integration, { index = index })
  }
  tenant_id     = local.tenant_id
  statement_id  = "AllowExecutionFromAPIGateway${each.value.index}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${local.api_id}/*/${each.value.method}${each.value.path}"
}
