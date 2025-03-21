module "tenant" {
  source         = "../tenant"
  infra_name     = var.infra_name
  parent         = var.parent
  name           = var.name
  settings       = var.settings
  configurations = var.configurations
  sg_rules       = var.sg_rules
  grants         = var.grants
}

module "iam" {
  count           = var.policy != null ? 1 : 0
  source          = "../tenant-role-extension"
  tenant_name     = var.name
  policy_name     = "${var.name}-custom"
  iam_policy_json = var.policy
}

resource "github_repository_environment" "this" {
  for_each = {
    for repo in var.repos : repo => var.name
  }
  repository  = each.key
  environment = each.value
}
