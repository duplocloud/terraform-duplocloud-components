locals {
  tenant              = data.duplocloud_tenant.this
  namespace           = "duploservices-${local.tenant.name}"
  release_id          = random_string.release_id.id
  image_uri           = var.image.uri != null ? var.image.uri : "${var.image.registry}/${coalesce(var.image.repo, var.name)}:${var.image.tag}"
  release_header_name = "X-Access-Control"
  cloud               = lower(var.cloud)
  host_network = var.host_network != null ? var.host_network : (
    local.cloud == "gcp" ? false : null
  )
  service_account_name = (
    var.service_account_name != null ? var.service_account_name : (
      local.cloud == "gcp" ? "${local.namespace}-app-user" : null
    )
  )
  volumes = concat([
    for config in module.configurations : config.volume if config.volume != null
    ], [
    # TODO pvc volume
  ], jsondecode(var.volumes_json))
  volume_mounts = concat(
    var.volume_mounts,
    flatten([
      for config in module.configurations : config.volumeMounts
      if config.volumeMounts != null
    ])
  )
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

check "hpa-with-resources" {
  assert {
    condition = !(
      var.scale.metrics != null &&
      var.resources.limits == null
    )
    error_message = <<EOT
When using autoscaling, it is highly recommended to set resources.
If the HPA is configured to scale on 80% CPU utilization but there
are no limits set, then the autoscaler will not actually work. 

Example: 
resources = {
  limits = {
    cpu    = "200m"
    memory = "512Mi"
  }
}

Learn how to set resources at:
https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
EOT
  }
}
