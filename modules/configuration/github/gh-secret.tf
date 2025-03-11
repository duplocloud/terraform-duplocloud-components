resource "github_actions_environment_secret" "managed" {
  count           = var.class == "gh-secret" && var.managed ? 1 : 0
  environment     = var.tenant
  secret_name     = var.name
  plaintext_value = var.value
  repository      = var.repository
}

resource "github_actions_environment_secret" "unmanaged" {
  count           = var.class == "gh-secret" && !var.managed ? 1 : 0
  environment     = var.tenant
  secret_name     = var.name
  plaintext_value = var.value
  repository      = var.repository
  lifecycle {
    ignore_changes = [plaintext_value]
  }
}
