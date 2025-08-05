module "loadbalancer" {
  count                    = var.lb.enabled ? 1 : 0
  source                   = "../loadbalancer"
  tenant                   = local.tenant.name
  name                     = local.service.name
  class                    = var.lb.class
  port                     = var.port
  external_port            = var.lb.port
  certificate              = var.lb.certificate
  protocol                 = var.lb.protocol
  listener                 = var.lb.listener
  priority                 = var.lb.priority
  path_pattern             = var.lb.path_pattern
  dns_prfx                 = var.lb.dns_prfx
  internal                 = var.lb.internal
  health_check_url         = var.health_check.path
  set_ingress_health_check = var.set_ingress_health_check
  annotations = merge(
    var.lb.annotations,
    var.lb.release_header ? {
      ("alb.ingress.kubernetes.io/conditions.${local.service.name}") = jsonencode([{
        Field = "http-header"
        HttpHeaderConfig = {
          HttpHeaderName = local.release_header_name
          Values         = [local.release_id]
        }
      }])
    } : {}
  )
}
