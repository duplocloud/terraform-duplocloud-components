locals {
  tenant            = data.duplocloud_tenant.this
  ingress_prefix    = "ingress-"
  standalone_prefix = "standalone-"
  is_ingress        = startswith(var.class, local.ingress_prefix)
  is_standalone     = startswith(var.class, local.standalone_prefix)
  ingress_class     = local.is_ingress ? replace(var.class, local.ingress_prefix, "") : null
  standalone_class  = local.is_standalone ? replace(var.class, local.standalone_prefix, "") : null
  # base_class = coalesce(
  #   local.ingress_class,
  #   local.standalone_class,
  #   var.class
  # )
  class = coalesce(
    local.is_ingress ? "service" : null,
    local.standalone_class,
    var.class
  )
  lbconfig_needed = contains(keys(local.duplo_types), local.class)
  cert_is_arn     = length(regexall("^arn:aws(-us-gov)?:acm", coalesce(var.certificate, "na"), )) > 0
  do_cert_lookup  = var.certificate != null && !local.cert_is_arn
  cert_arn        = local.do_cert_lookup ? data.duplocloud_plan_certificate.this[0].arn : var.certificate
  external_port = (
    var.external_port != null ? var.external_port :
    var.certificate != null ? 443 :
    local.class == "service" ? var.port :
  80)
  dns_prfx       = coalesce(var.dns_prfx, "${var.name}-${var.tenant}")
  https_redirect = var.certificate != null ? true : false
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
  duplo_type = local.duplo_types[local.class]
  protocol   = var.protocol != null ? upper(var.protocol) : local.duplo_type.protocols[0]
  duplo_types = {
    "elb" = {
      id        = 0
      protocols = ["HTTP", "HTTPS", "TCP", "UDP"]
    }
    "alb" = {
      id        = 1
      protocols = ["HTTP", "HTTPS"]
    }
    "health-only" = {
      id        = 2
      protocols = ["HTTP", "HTTPS", "TCP", "UDP", "TLS"] # this is ignored so all values allowed cuz it don't matter
    }
    "service" = {
      id        = 3
      protocols = ["TCP", "UDP"]
    }
    "node-port" = {
      id        = 4
      protocols = ["TCP", "UDP"]
    }
    "azure-shared-gateway" = {
      id        = 5
      protocols = ["HTTP", "HTTPS"]
    }
    "nlb" = {
      id        = 6
      protocols = ["TCP", "UDP", "TLS"]
    }
    "target-group" = {
      id        = 7
      protocols = ["HTTP", "HTTPS"]
    }
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

check "class-accepts-protocol" {
  assert {
    condition     = contains(local.duplo_type.protocols, local.protocol)
    error_message = <<EOT
The chosen protocol ${local.protocol} won't be accepted by the load balancer type "${local.class}".
EOT
  }
}
