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
        lookup(local.workflows, each.key, { context = {} }).context,         # the user inputs
      )
    )
  )
  # depends_on = [
  #   github_repository_ruleset.default_branch
  # ]
}
