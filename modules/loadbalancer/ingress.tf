resource "duplocloud_k8_ingress" "this" {
  count              = local.is_ingress ? 1 : 0
  tenant_id          = local.tenant.id
  name               = var.name
  ingress_class_name = local.ingress_class
  annotations        = local.ingress_annotations
  labels             = var.labels
  lbconfig {
    is_internal     = var.internal
    dns_prefix      = local.dns_prfx
    http_port       = var.certificate != null ? 80 : local.external_port
    https_port      = var.certificate != null ? local.external_port : null
    certificate_arn = var.certificate
  }
  rule {
    path         = var.path_pattern
    path_type    = "ImplementationSpecific"
    service_name = var.name
    port         = var.port
  }
  depends_on = [
    duplocloud_duplo_service_lbconfigs.this[0]
  ]
}
