resource "duplocloud_aws_lambda_permission" "permission" {
  for_each = {
    for index, integration in local.lambda_integrations :
    "${integration.path}/${integration.method}/${integration.name}" => merge(integration, { tag = substr(replace("${integration.path}${integration.method}", "/[^a-zA-Z0-9]/", ""), 0, 100) })
  }
  tenant_id     = local.tenant_id
  statement_id  = "ExecFromAPIGW${each.value.tag}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${local.api_id}/*/${each.value.method}${each.value.path}"
}
