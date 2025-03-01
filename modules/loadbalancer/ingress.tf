resource "duplocloud_k8_ingress" "this" {
  count              = local.is_ingress ? 1 : 0
  tenant_id          = local.tenant.id
  name               = var.name
  ingress_class_name = local.ingress_class
  lbconfig {
    is_internal     = var.internal
    dns_prefix      = local.dns_prfx
    certificate_arn = var.certificate
    https_port      = local.external_port
  }
  rule {
    path         = var.path_pattern
    path_type    = "ImplementationSpecific"
    service_name = var.name
    port         = var.port
  }
}
