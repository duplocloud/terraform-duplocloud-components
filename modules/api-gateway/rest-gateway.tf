resource "aws_api_gateway_rest_api" "this" {
  count = local.class.version == "v1" ? 1 : 0
  name  = local.fullname

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  body = yamlencode(local.body)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_api_gateway_deployment" "this" {
  count = local.class.version == "v1" ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this[0].id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this[0].body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "default" {
  count = local.class.version == "v1" ? 1 : 0

  stage_name    = "default"
  deployment_id = aws_api_gateway_deployment.this[0].id
  rest_api_id   = aws_api_gateway_rest_api.this[0].id
}

resource "aws_api_gateway_vpc_link" "this" {
  count       = var.enable_private_link && local.class.version == "v1" ? 1 : 0
  name        = local.fullname
  description = "Private connections for ${var.name} in ${var.tenant_name}"
  target_arns = var.vpc_link_targets
}

resource "aws_api_gateway_domain_name" "this" {
  for_each = local.class.version == "v1" ? local.managed_domains : {}
  # tflint-ignore: aws_api_gateway_domain_name_invalid_security_policy
  domain_name              = each.value.domain_name
  regional_certificate_arn = each.value.do_cert_lookup ? data.duplocloud_plan_certificate.this[each.key].arn : each.value.cert
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  for_each    = local.class.version == "v1" ? var.mappings : {}
  api_id      = aws_api_gateway_rest_api.this[0].id
  stage_name  = aws_api_gateway_stage.default[0].stage_name
  domain_name = each.value.external ? each.value.domain_name : aws_api_gateway_domain_name.this[0].domain_name
  base_path   = each.value.path
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "rest_gateway" {
  for_each = aws_api_gateway_domain_name.this
  name    = each.value.domain_name
  type    = "A"
  zone_id = local.zone_id
  alias {
    name                   = each.value.regional_domain_name
    zone_id                = each.value.regional_zone_id
    evaluate_target_health = false
  }
}
