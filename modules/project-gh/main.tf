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
  workflow_context = {
    name    = var.name
    ref     = "main"
    cloud   = var.cloud
    props   = local.props
    use_app = false
  }
  default_workflows = {
    image = {
      enabled    = true
      content    = null
      conditions = local.condition.service
      context    = {}
    }
    update_image = {
      enabled    = true
      conditions = local.condition.service
      content    = null
      context    = {}
    }
  }
  default_workflow_keys = keys(local.default_workflows)
  ##
  # First merge the user provided workflows and the default workflows
  # This will cause the conditions to be nulled out if the user updated 
  # the workflow values. We need the default conditions back when this happens. 
  # If it's some user defined workflow with null conditions then empty object it is
  ## 
  workflows = {
    for name, workflow in merge(local.default_workflows, var.workflows) : name => merge(
      workflow,
      {
        conditions = (
          contains(local.default_workflow_keys, name) &&
          workflow.conditions == null
        ) ? local.default_workflows[name].conditions : coalesce(workflow.conditions, {})
      }
    )
  }
  ##
  # This is basically saying for each of the workflows;
  # first check if the repo has any properties that exist in the condition
  # If so, then make sure the actual value is one of the allowed values in the condition
  # Then we can say it's active
  ## 
  active_workflows = [
    for name, workflow in local.workflows : name
    if workflow.enabled && anytrue([
      for k, allowed in workflow.conditions : anytrue([
        for v in lookup(local.props, k, []) : contains(allowed, v)
      ])
    ])
  ]
}

##
# Retrieves the top level files from the repo. 
# This enables us to check if files exist before operating on them. 
# Normally TF has issues with this because it doesn't know what to do when a resource already exists. 
# With this we can even make changes to files if needed. 
##
data "github_rest_api" "root_files" {
  endpoint = "repos/${var.owner}/${var.name}/contents"
}
