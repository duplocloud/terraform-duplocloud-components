locals {
  service = var.image.managed ? duplocloud_duplo_service.managed[0] : duplocloud_duplo_service.unmanaged[0]
  duplocloud_clouds = {
    "AWS" : 0,
    "ORACLE" : 1,
    "AZURE" : 2,
    "GCP" : 3,
    "BYOH" : 4
  }
  duplocloud_cloud = local.duplocloud_clouds[var.cloud]
  other_docker_config = yamldecode(templatefile("${path.module}/templates/service.yaml", {
    env_from                 = jsonencode(local.env_from)
    image                    = var.image
    port                     = var.port
    health_check             = var.health_check
    host_network             = var.host_network
    nodes                    = var.nodes
    termination_grace_period = var.termination_grace_period
    deployment_strategy      = jsonencode(var.deployment_strategy)
    restart_policy           = var.restart_policy
    annotations              = jsonencode(var.annotations)
    labels                   = jsonencode(var.labels)
    pod_labels               = jsonencode(var.pod_labels)
    pod_annotations          = jsonencode(var.pod_annotations)
    service_account_name     = var.service_account_name
    security_context         = jsonencode(var.security_context != null ? var.security_context : {})
    volume_mounts            = jsonencode(local.volume_mounts)
    volumes                  = jsonencode(local.volumes)
    command                  = jsonencode(var.command)
    args                     = jsonencode(var.args)
    env                      = jsonencode(local.container_env)
    resources = {
      # don't actuall print the null values
      for key, value in var.resources : key => value
      if value != null
    }
  }))
  hpa_metrics = lookup(var.scale, "metrics", null)
  hpa_specs = yamldecode(templatefile("${path.module}/templates/hpa-spec.yaml", {
    minReplicas = var.scale.min
    maxReplicas = var.scale.max
    metrics     = local.hpa_metrics
  }))
}

# the tf managed resource block
resource "duplocloud_duplo_service" "managed" {
  count                                = var.image.managed ? 1 : 0
  tenant_id                            = local.tenant.id
  name                                 = var.name
  replicas                             = var.scale.replicas
  allocation_tags                      = var.nodes.allocation_tags
  any_host_allowed                     = var.nodes.shared
  is_unique_k8s_node_required          = var.nodes.unique
  should_spread_across_zones           = var.nodes.spread_across_zones
  lb_synced_deployment                 = false
  cloud_creds_from_k8s_service_account = true
  is_daemonset                         = false
  agent_platform                       = 7
  cloud                                = local.duplocloud_cloud
  other_docker_config                  = jsonencode(local.other_docker_config)
  hpa_specs                            = local.hpa_metrics != null ? jsonencode(local.hpa_specs) : null
  docker_image                         = local.image_uri
  depends_on                           = [duplocloud_k8s_job.before_update]

  lifecycle {
    ignore_changes = [any_host_allowed]
  }
}

# this services image and maybe the other docker config is not managed by tf
# this expectes you are using the duploctl cli to update these after tf runs
resource "duplocloud_duplo_service" "unmanaged" {
  count                                = var.image.managed ? 0 : 1
  tenant_id                            = local.tenant.id
  name                                 = var.name
  replicas                             = var.scale.replicas
  allocation_tags                      = var.nodes.allocation_tags
  any_host_allowed                     = var.nodes.shared
  is_unique_k8s_node_required          = var.nodes.unique
  should_spread_across_zones           = var.nodes.spread_across_zones
  lb_synced_deployment                 = false
  cloud_creds_from_k8s_service_account = true
  is_daemonset                         = false
  agent_platform                       = 7
  cloud                                = local.duplocloud_cloud
  other_docker_config                  = jsonencode(local.other_docker_config)
  hpa_specs                            = local.hpa_metrics != null ? jsonencode(local.hpa_specs) : null
  docker_image                         = local.image_uri
  depends_on                           = [duplocloud_k8s_job.before_update]
  lifecycle {
    ignore_changes = [
      docker_image,
      any_host_allowed
    ]
  }
}
