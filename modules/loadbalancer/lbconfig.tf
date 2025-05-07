resource "duplocloud_duplo_service_lbconfigs" "this" {
  count                       = local.lbconfig_needed ? 1 : 0
  tenant_id                   = local.tenant.id
  replication_controller_name = var.name
  lbconfigs {
    lb_type          = local.duplo_type.id
    is_native        = false
    is_internal      = var.internal
    port             = var.port
    external_port    = local.is_ingress ? var.port : local.external_port
    certificate_arn  = var.certificate
    protocol         = local.protocol
    health_check_url = var.health_check_url
    # backend_protocol_version = "HTTP1"
  }
  lifecycle {
    ignore_changes = [
      lbconfigs[0].backend_protocol_version
    ]
  }
}

resource "duplocloud_duplo_service_params" "this" {
  count                       = local.lbconfig_needed && !local.is_ingress ? 1 : 0
  tenant_id                   = local.tenant.id
  replication_controller_name = var.name
  dns_prfx                    = local.dns_prfx
  enable_access_logs          = false
  drop_invalid_headers        = false
  http_to_https_redirect      = local.https_redirect
  idle_timeout                = 60
  depends_on = [
    duplocloud_duplo_service_lbconfigs.this[0]
  ]
}
