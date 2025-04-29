locals {
  repo = one(
    var.mode == "data" ? data.github_repository.this : github_repository.this
  )
  custom_properties = one(data.github_repository_custom_properties.this)
  props = local.custom_properties == null ? {} : {
    for p in local.custom_properties.property : p.property_name => tolist(p.property_value)
  }
  prop_keys = keys(local.props)
  condition = {
    service = {
      has_image = ["true"]
      class     = ["service"]
    }
  }
  workflows = merge({
    image = {
      enabled    = true
      conditions = local.condition.service
      content    = null
    }
    update_image = {
      enabled    = true
      conditions = local.condition.service
      content    = null
    }
  }, var.workflows)
  active_workflows = [
    for name, workflow in local.workflows : name
    if workflow.enabled && anytrue([
      for k, allowed in workflow.conditions : anytrue([
        for v in lookup(local.props, k, []) : contains(allowed, v)
      ])
    ])
  ]
}
