resource "duplocloud_aws_lb_listener_rule" "target-group" {
  count        = local.class == "target-group" ? 1 : 0
  tenant_id    = local.tenant.id
  listener_arn = var.listener
  priority     = var.priority
  action {
    type             = "forward"
    target_group_arn = duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].target_group_arn
  }
  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
  depends_on = [
    duplocloud_duplo_service_lbconfigs.this[0]
  ]
}
