resource "aws_apigatewayv2_api" "this" {
  count         = local.class.version == "v2" ? 1 : 0
  name          = local.fullname
  description   = "Gateway for ${var.name} within ${var.tenant_name}"
  protocol_type = "HTTP"
  body          = yamlencode(local.body)
  tags          = local.base_tags
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
    max_age       = 600
  }
  lifecycle {
    ignore_changes = [
      tags,
      tags_all,
      version
    ]
  }
}

resource "aws_cloudwatch_log_group" "api_gateway" {
  count = local.class.version == "v2" ? 1 : 0
  name  = "/${var.tenant_name}/gateway/${var.name}"
  tags  = local.base_tags
}

resource "aws_apigatewayv2_stage" "default" {
  count       = local.class.version == "v2" ? 1 : 0
  api_id      = aws_apigatewayv2_api.this[0].id
  name        = "default"
  auto_deploy = true
  tags        = local.base_tags

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway[0].arn
    format = jsonencode({
      "requestId" : "$context.requestId",
      "ip" : "$context.identity.sourceIp",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "routeKey" : "$context.routeKey",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength",
      "path" : "$context.path",
      "basePathMatched" : "$context.customDomain.basePathMatched"
    })
  }
}

resource "aws_apigatewayv2_vpc_link" "this" {
  count = local.class.version == "v2" && var.enable_private_link ? 1 : 0
  name  = local.fullname
  security_group_ids = [
    local.sg_infra[index(local.sg_infra[*].name, "duplo-allhosts")].id,
    data.aws_security_group.tenant.id
  ]
  subnet_ids = data.duplocloud_tenant_internal_subnets.this.subnet_ids
  tags       = local.base_tags
}

resource "aws_apigatewayv2_domain_name" "this" {
  for_each = local.class.version == "v2" ? local.managed_domains : {}
  # tflint-ignore: aws_api_gateway_domain_name_invalid_security_policy
  domain_name = each.value.domain_name
  domain_name_configuration {
    certificate_arn = each.value.do_cert_lookup ? data.duplocloud_plan_certificate.this[each.key].arn : each.value.cert
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
  tags = local.base_tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  for_each        = local.class.version == "v2" ? var.mappings : {}
  api_id          = aws_apigatewayv2_api.this[0].id
  domain_name     = each.value.external ? each.value.domain_name : aws_apigatewayv2_domain_name.this[each.key].id
  stage           = aws_apigatewayv2_stage.default[0].id
  api_mapping_key = each.value.path
}

## 
# Make route53 records only for the managed domains that were created. 
# Since the domains will be empty if a v1 class is used, this will be empty too, no ifs needed. 
##
resource "aws_route53_record" "http_gateway" {
  for_each = aws_apigatewayv2_domain_name.this
  name    = each.value.domain_name
  type    = "A"
  zone_id = local.zone_id
  alias {
    name                   = each.value.domain_name_configuration[0].target_domain_name
    zone_id                = each.value.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
