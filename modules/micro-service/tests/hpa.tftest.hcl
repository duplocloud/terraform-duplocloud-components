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


