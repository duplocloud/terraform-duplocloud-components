locals {
  tenant            = data.duplocloud_tenant.this
  ingress_prefix    = "ingress-"
  standalone_prefix = "standalone-"
  is_ingress        = startswith(var.class, local.ingress_prefix)
  is_standalone     = startswith(var.class, local.standalone_prefix)
  ingress_class     = local.is_ingress ? replace(var.class, local.ingress_prefix, "") : null
  class             = local.is_ingress ? "service" : var.class
  lbconfig_needed   = contains(keys(local.duplo_types), local.class)
  cert_is_arn       = length(regexall("^arn:aws(-us-gov)?:acm", coalesce(var.certificate, "na"), )) > 0
  do_cert_lookup    = var.certificate != null && !local.cert_is_arn
  cert_arn          = local.do_cert_lookup ? data.duplocloud_plan_certificate.this[0].arn : var.certificate
  external_port     = (var.external_port != null ? var.external_port : 
                      var.certificate != null ? 443 :
                      local.class == "service" ? var.port : 80)
  dns_prfx          = coalesce(var.dns_prfx, "${var.name}-${var.tenant}")
  https_redirect    = var.certificate != null ? true : false
  ingress_annotations = local.is_ingress ? {
    for key, value in merge(
      var.annotations,
      {
        "kubernetes.io/ingress.class"                = local.ingress_class
        "alb.ingress.kubernetes.io/ssl-redirect"     = local.https_redirect ? tostring(local.external_port) : null
        "alb.ingress.kubernetes.io/target-type"      = "ip"
        "alb.ingress.kubernetes.io/healthcheck-path" = var.health_check_url
      }
    ) : key => value
    if value != null
  } : null
  duplo_types = {
    "elb"                  = 0
    "alb"                  = 1
    "health-only"          = 2
    "service"              = 3
    "node-port"            = 4
    "azure-shared-gateway" = 5
    "nlb"                  = 6
    "target-group"         = 7
  }
}

# If the tenant_id is not set, we need to look it up with the tenant data block
data "duplocloud_tenant" "this" {
  name = var.tenant
}

# now check for the cert arn when we need to do_cert_lookup
data "duplocloud_plan_certificate" "this" {
  count   = local.do_cert_lookup ? 1 : 0
  name    = var.certificate
  plan_id = local.tenant.plan_id
}

data "duplocloud_infrastructure" "this" {
  count      = local.is_standalone ? 1 : 0
  infra_name = local.tenant.plan_id
}
