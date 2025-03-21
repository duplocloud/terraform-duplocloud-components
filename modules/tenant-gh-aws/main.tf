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
  tenant_name     = module.tenant.name
  policy_name     = "${module.tenant.name}-custom"
  iam_policy_json = var.policy
}

resource "github_repository_environment" "this" {
  for_each    = toset(var.repos)
  repository  = each.key
  environment = module.tenant.name
}
