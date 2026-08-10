variables {
  tenant = "tf-tests"
  name   = "myapp"
  class  = "alb"
}

mock_provider "duplocloud" {
  mock_data "duplocloud_tenant" {
    defaults = {
      id      = "c4b717db-a61b-4edc-b895-37c3dfa58fa8"
      name    = "tf-tests"
      plan_id = "myinfra"
    }
  }
}

run "hpa_defaults" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    scale  = {}
  }

  assert {
    condition = (
      local.hpa_metrics == null &&
      local.hpa_specs == null
    )
    error_message = "The hpa_metrics should be null."
  }
}

run "hpa_with_resources" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    resources = {
      limits = {
        cpu    = "200m"
        memory = "512Mi"
      }
    }
    scale = {
      replicas = 3
      min      = 2
      max      = 10
      metrics = [{
        type = "Resource"
        resource = {
          name = "cpu"
          target = {
            type               = "Utilization"
            averageUtilization = 50
          }
        }
      }]
    }
  }
  assert {
    condition = (
      local.hpa_metrics != null &&
      length(local.hpa_metrics) == 1
    )
    error_message = "The hpa_metrics should be null."
  }
}

run "hpa_behavior_omitted" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    resources = {
      limits = {
        cpu    = "200m"
        memory = "512Mi"
      }
    }
    scale = {
      min = 2
      max = 10
      metrics = [{
        type = "Resource"
        resource = {
          name   = "cpu"
          target = { type = "Utilization", averageUtilization = 50 }
        }
      }]
    }
  }

  assert {
    condition     = !can(local.hpa_specs.behavior)
    error_message = "The hpa spec should have no behavior key when behavior is not given."
  }
}

run "hpa_behavior" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    resources = {
      limits = {
        cpu    = "200m"
        memory = "512Mi"
      }
    }
    scale = {
      min = 2
      max = 10
      metrics = [{
        type = "Resource"
        resource = {
          name   = "cpu"
          target = { type = "Utilization", averageUtilization = 50 }
        }
      }]
      behavior = {
        scaleUp = {
          stabilizationWindowSeconds = 120
          policies                   = [{ type = "Pods", value = 2, periodSeconds = 120 }]
        }
        scaleDown = {
          stabilizationWindowSeconds = 1800
          selectPolicy               = "Min"
          policies                   = [{ type = "Pods", value = 1, periodSeconds = 600 }]
        }
      }
    }
  }

  assert {
    condition = (
      local.hpa_specs.behavior.scaleUp.stabilizationWindowSeconds == 120 &&
      length(local.hpa_specs.behavior.scaleUp.policies) == 1 &&
      local.hpa_specs.behavior.scaleUp.policies[0].type == "Pods" &&
      local.hpa_specs.behavior.scaleUp.policies[0].value == 2 &&
      local.hpa_specs.behavior.scaleUp.policies[0].periodSeconds == 120
    )
    error_message = "The scaleUp behavior was not rendered correctly."
  }

  assert {
    condition = (
      local.hpa_specs.behavior.scaleDown.stabilizationWindowSeconds == 1800 &&
      local.hpa_specs.behavior.scaleDown.selectPolicy == "Min" &&
      local.hpa_specs.behavior.scaleDown.policies[0].periodSeconds == 600
    )
    error_message = "The scaleDown behavior was not rendered correctly."
  }

  assert {
    condition     = !can(local.hpa_specs.behavior.scaleUp.selectPolicy)
    error_message = "An unset selectPolicy should be omitted rather than rendered as null."
  }
}

# an empty behavior, direction, or policy list should be dropped entirely so the
# rendered spec never carries a null in place of an object or list
run "hpa_behavior_empty" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    resources = {
      limits = {
        cpu    = "200m"
        memory = "512Mi"
      }
    }
    scale = {
      min = 2
      max = 10
      metrics = [{
        type = "Resource"
        resource = {
          name   = "cpu"
          target = { type = "Utilization", averageUtilization = 50 }
        }
      }]
      behavior = {
        scaleUp = { policies = [] }
      }
    }
  }

  assert {
    condition     = !can(local.hpa_specs.behavior)
    error_message = "A behavior with no effective values should be omitted from the hpa spec."
  }
}

run "hpa_behavior_one_direction" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    resources = {
      limits = {
        cpu    = "200m"
        memory = "512Mi"
      }
    }
    scale = {
      min = 2
      max = 10
      metrics = [{
        type = "Resource"
        resource = {
          name   = "cpu"
          target = { type = "Utilization", averageUtilization = 50 }
        }
      }]
      behavior = {
        scaleDown = { stabilizationWindowSeconds = 900 }
      }
    }
  }

  assert {
    condition = (
      local.hpa_specs.behavior.scaleDown.stabilizationWindowSeconds == 900 &&
      !can(local.hpa_specs.behavior.scaleUp)
    )
    error_message = "Only the configured direction should be present in the behavior block."
  }
}


