locals {
  ## 
  # Global variables for all of the workflows
  ##
  workflow_context = {
    name    = var.name
    ref     = "main"
    cloud   = var.cloud
    props   = local.props
    use_app = false
  }
  ##
  # The pre-made by Duplocloud workflows and templates. 
  # The content for these are the workflows in the workflows directory.
  # These can be simply enabled or disabled and user can even override them. 
  ## 
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
# Builds the actual file and commits it to the designated repo. 
## 
resource "github_repository_file" "workflows" {
  for_each = {
    for name in local.active_workflows : name => local.workflows[name]
  }
  repository          = var.name
  branch              = local.repo.default_branch
  commit_message      = "Update image workflow from ${var.owner}[bot] using Terraform"
  overwrite_on_create = true
  file                = ".github/workflows/${each.key}.yml"
  content = (each.value.content != null ? each.value.content :
    templatefile(
      "${path.module}/workflows/${each.key}.yml",
      merge(
        {
          id      = each.key
          enabled = each.value.enabled
        },                                                                   # specific to the loop
        local.workflow_context,                                              # the globals
        lookup(local.default_workflows, each.key, { context = {} }).context, # the defaults
        coalesce(each.value.context, {})                                     # the user input
      )
    )
  )
  # depends_on = [
  #   github_repository_ruleset.default_branch
  # ]
}
