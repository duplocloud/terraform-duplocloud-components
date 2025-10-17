# tflint-ignore
locals {

  # names 
  shortname = "${var.tenant_name}-${var.name}"
  fullname  = "duplo-${local.shortname}"
  namespace = "duploservices-${var.tenant_name}"

  # context for placement so we know the region and security groups
  sg_infra = tolist(data.duplocloud_infrastructure.this.security_groups)
  region   = data.duplocloud_infrastructure.this.region

  # deal with the domains now
  base_domain = data.duplocloud_plan_settings.this.dns_setting[0].external_dns_suffix
  managed_domains = {
    for mapping in var.mappings : mapping.domain => {
      # any dots at all means we have an FQDN, if none then we append the base domain
      domain_name = contains(mapping.domain, ".") ? mapping.domain : "${mapping.domain}${local.base_domain}"
      cert        = mapping.cert
      do_cert_lookup = (
        !(length(
          regexall("^arn:aws(-us-gov)?:acm", coalesce(mapping.cert, "na"), )
        ) > 0) && mapping.cert != null
      )
    }
    if !mapping.external
  }

  # all of the IDs we need
  tenant_id  = data.duplocloud_tenant.this.id
  account_id = data.duplocloud_aws_account.this.account_id
  plan_id    = data.duplocloud_tenant.this.plan_id
  zone_id    = data.duplocloud_plan_settings.this.dns_setting[0].domain_id
  api_id     = local.api.id
  api        = one(local.class.version == "v2" ? aws_apigatewayv2_api.this : aws_api_gateway_rest_api.this)

  # parse template for the default or the given open api file
  body_vars = merge(var.openapi_variables, {
    AWS_ACCOUNT_ID = local.account_id
    AWS_REGION     = local.region
    DUPLO_TENANT   = var.tenant_name
  })
  body_text = (var.body != null ? var.body :
    var.openapi_file == null ? file("${path.module}/openapi.yaml") :
  templatefile(var.openapi_file, local.body_vars))
  body = yamldecode(local.body_text)

  # find all of the lambda integrations
  lambda_integrations = flatten([
    for path, methods in local.body.paths : [
      for method, details in methods : {
        path        = path
        method      = upper(method)
        integration = details["x-amazon-apigateway-integration"]
        name        = regex("function:([^/]+)", details["x-amazon-apigateway-integration"].uri)[0]
      } if can(regex("arn:aws:lambda", details["x-amazon-apigateway-integration"].uri))
    ]
  ])

  # common duplocloud base tags
  base_tags = {
    TENANT_NAME   = var.tenant_name
    duplo-project = var.tenant_name
  }

  # make the classes for default values
  class = local.classes[var.class]
  classes = {
    http = {
      version = "v2"
      private = false
    }
    rest = {
      version = "v1"
      private = false
    }
    rest-private = {
      version = "v1"
      private = true
    }
    websocket = {
      version = "v1"
      private = false
    }
  }
}
# tflint-ignore-end
data "duplocloud_aws_account" "this" {}

data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

data "duplocloud_infrastructure" "this" {
  tenant_id = local.tenant_id
}

data "aws_security_group" "tenant" {
  name = local.namespace
}

data "duplocloud_plan_settings" "this" {
  plan_id = local.plan_id
}

data "duplocloud_tenant_internal_subnets" "this" {
  tenant_id = local.tenant_id
}

# this does the cert lookup for the domains with named certs
data "duplocloud_plan_certificate" "this" {
  for_each = {
    for key, domain in local.managed_domains : key => domain
    if domain.do_cert_lookup
  }
  name    = each.value.cert
  plan_id = local.plan_id
}
