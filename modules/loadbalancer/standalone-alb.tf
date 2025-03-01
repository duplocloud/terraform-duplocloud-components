# the standalone alb itself
resource "duplocloud_aws_load_balancer" "this" {
  count                = local.is_standalone ? 1 : 0
  tenant_id            = local.tenant.id
  name                 = var.name
  load_balancer_type   = "application"
  enable_access_logs   = false
  is_internal          = var.internal
  drop_invalid_headers = false
  idle_timeout         = 60
}

# duplo bug prevents deletion of target group, it must prefix custom-
resource "duplocloud_aws_lb_target_group" "this" {
  count       = local.is_standalone ? 1 : 0
  tenant_id   = local.tenant.id
  name        = "custom-${var.name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.duplocloud_infrastructure.this[0].vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 300
    path                = var.health_check_url
    port                = "80"
    protocol            = "HTTP"
    timeout             = 60
    unhealthy_threshold = 3
  }
}

resource "duplocloud_aws_load_balancer_listener" "default" {
  count              = local.is_standalone ? 1 : 0
  tenant_id          = local.tenant.id
  load_balancer_name = duplocloud_aws_load_balancer.this[0].name
  certificate_arn    = local.cert_arn
  protocol           = local.cert_arn != null ? "HTTPS" : "HTTP"
  port               = local.external_port
  target_group_arn   = duplocloud_aws_lb_target_group.this[0].arn
}

resource "duplocloud_aws_lb_listener_rule" "default" {
  count        = local.is_standalone ? 1 : 0
  tenant_id    = local.tenant.id
  listener_arn = duplocloud_aws_load_balancer_listener.default[0].arn
  priority     = 97
  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }
  condition {
    path_pattern {
      values = [
        var.health_check_url
      ]
    }
  }
}
