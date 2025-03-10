locals {
  tenant     = data.duplocloud_tenant.this
  release_id = random_string.release_id.id
  image_uri  = var.image.uri != null ? var.image.uri : "${var.image.registry}/${coalesce(var.image.repo, var.name)}:${var.image.tag}"
  volumes = concat([
    for config in module.configurations : config.volume if config.volume != null
    ], [
    # TODO pvc volume
  ], jsondecode(var.volumes_json))
  volume_mounts = concat([
    for config in module.configurations : config.volumeMount
    if config.volumeMount != null
  ], var.volume_mounts)
  # for each key value in var.env make a list of objects with name and value
  container_env = [
    for key, value in var.env : {
      name  = key
      value = value
    }
  ]
  # build from the single env configmap and all of the secret names
  env_from = concat([
    for config in module.configurations : config.envFrom
    if config.envFrom != null
    ], [
    for secret in var.secrets : {
      secretRef : {
        name = secret
      }
    }
  ])
}

# If the tenant_id is not set, we need to look it up with the tenant data block
data "duplocloud_tenant" "this" {
  name = var.tenant
}

resource "random_string" "release_id" {
  keepers = {
    strategy = var.release_id != null ? var.release_id : local.image_uri
  }
  length  = 5
  special = false
  upper   = false
}

check "tenant" {
  assert {
    condition     = local.tenant.id != null
    error_message = "The tenant id should not be null."
  }
}
