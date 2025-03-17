resource "duplocloud_plan_configs" "this" {
  count   = var.configs != null ? 1 : 0
  plan_id = local.name
  dynamic "config" {
    for_each = {
      for conf in var.configs : "${conf.type}-${conf.key}" => conf
    }
    content {
      key   = config.value.key
      type  = config.value.type
      value = config.value.value
    }
  }
}
resource "duplocloud_plan_settings" "this" {
  plan_id             = local.name
  unrestricted_ext_lb = true
  dynamic "dns_setting" {
    for_each = var.dns != null ? [1] : []
    content {
      domain_id           = var.dns.domain_id
      internal_dns_suffix = var.dns.internal_suffix
      external_dns_suffix = var.dns.external_suffix
      ignore_global_dns   = var.dns.ignore_global
    }

  }
  dynamic "metadata" {
    for_each = var.metadata
    content {
      key   = metadata.key
      value = metadata.value
    }
  }
}

resource "duplocloud_plan_certificates" "this" {
  count   = var.certificates != null ? 1 : 0
  plan_id = local.name
  dynamic "certificate" {
    for_each = var.certificates
    content {
      name = certificate.key
      id   = certificate.value
    }
  }
}
