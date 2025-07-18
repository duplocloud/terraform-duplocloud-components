resource "duplocloud_k8_config_map" "managed" {
  count = (
    var.class == "configmap" &&
    var.managed &&
    !var.external
  ) ? 1 : 0
  tenant_id = var.tenant_id
  name      = local.name
  data      = local.value
  timeouts {
    create = "3m"
    update = "3m"
    delete = "3m"
  }
}

resource "duplocloud_k8_config_map" "unmanaged" {
  count = (
    var.class == "configmap" &&
    !var.managed &&
    !var.external
  ) ? 1 : 0
  tenant_id = var.tenant_id
  name      = local.name
  data      = local.value
  timeouts {
    create = "3m"
    update = "3m"
    delete = "3m"
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}
