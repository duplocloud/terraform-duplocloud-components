resource "duplocloud_duplo_service_lbconfigs" "this" {
  count                       = var.lb.enabled ? 1 : 0
  tenant_id                   = local.tenant.id
  replication_controller_name = local.service.name
  lbconfigs {
    lb_type          = local.alb_types[var.lb.type]
    is_native        = false
    is_internal      = false
    port             = var.port
    external_port    = local.external_port
    certificate_arn  = local.cert_arn
    protocol         = var.lb.protocol
    health_check_url = var.health_check.path
  }
}

resource "duplocloud_duplo_service_params" "this" {
  count                       = var.lb.enabled ? 1 : 0
  tenant_id                   = local.tenant.id
  replication_controller_name = local.service.name
  dns_prfx                    = local.dns_prfx
  enable_access_logs          = false
  drop_invalid_headers        = false
  http_to_https_redirect      = local.cert_arn != "" ? true : false
  idle_timeout                = 60
}

resource "duplocloud_aws_lb_listener_rule" "this" {
  count        = var.lb.enabled && var.lb.type == "target-group" ? 1 : 0
  tenant_id    = local.tenant.id
  listener_arn = var.lb.listener
  priority     = var.lb.priority
  action {
    type             = "forward"
    target_group_arn = duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].target_group_arn
  }
  condition {
    path_pattern {
      values = [var.lb.path_pattern]
    }
  }
  depends_on = [
    duplocloud_duplo_service_lbconfigs.this[0]
  ]
}
