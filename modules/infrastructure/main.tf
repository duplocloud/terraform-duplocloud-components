locals {
  name = duplocloud_infrastructure.this.infra_name

  ##
  # The duplo provider likes to use numbers
  # The module likes to use human readable names. 
  # The cloud variable might be null, so the classmap will be used instead for default values.
  clouds = {
    aws    = 0
    oracle = 1
    azure  = 2
    gcp    = 3
  }
  cloud = coalesce(
    var.cloud,
    local.classmap[var.class].cloud,
    "aws"
  )
  address_prefix = var.address_prefix != null ? var.address_prefix : data.external.cidrinc[0].result.next
  has_plan_settings = (
    var.dns != null || var.metadata != null
  )

  classdef = local.classmap[var.class]
  classmap = {
    k8s = {
      cloud         = null
      has_k8s       = true
      has_ecs       = false
      has_autopilot = false
    }
    ecs = {
      cloud         = "aws"
      has_k8s       = false
      has_ecs       = true
      has_autopilot = false
    }
    eks = {
      cloud         = "aws"
      has_k8s       = true
      has_ecs       = false
      has_autopilot = false
    }
    gke = {
      cloud         = "gcp"
      has_k8s       = true
      has_ecs       = false
      has_autopilot = false
    }
    gke-autopilot = {
      cloud         = "gcp"
      has_k8s       = true
      has_ecs       = false
      has_autopilot = true
    }
    duplocloud = {
      cloud         = null
      has_k8s       = false
      has_ecs       = false
      has_autopilot = false
    }
  }
}

data "duplocloud_infrastructures" "all" {
  count = var.address_prefix == null ? 1 : 0
}

# tflint-ignore: terraform_required_providers
data "external" "cidrinc" {
  count = var.address_prefix == null ? 1 : 0
  program = concat([
    "${path.module}/cidrinc.sh"
    ], [
    for infra in data.duplocloud_infrastructures.all[0].data : infra.address_prefix
  ])
}
