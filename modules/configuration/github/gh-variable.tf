resource "github_actions_environment_variable" "managed" {
  count         = var.class == "gh-variable" && var.managed ? 1 : 0
  environment   = var.tenant
  variable_name = var.name
  value         = var.value
  repository    = var.repository
}

resource "github_actions_environment_variable" "unmanaged" {
  count         = var.class == "gh-variable" && !var.managed ? 1 : 0
  environment   = var.tenant
  variable_name = var.name
  value         = var.value
  repository    = var.repository
  lifecycle {
    ignore_changes = [value]
  }
}
