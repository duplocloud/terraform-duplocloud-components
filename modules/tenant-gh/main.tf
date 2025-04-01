module "tenant" {
  source         = "../tenant"
  infra_name     = var.infra_name
  parent         = var.parent
  name           = var.name
  settings       = var.settings
  configurations = var.configurations
  security_rules = var.security_rules
  grants         = var.grants
}

resource "github_repository_environment" "this" {
  for_each    = toset(var.repos)
  repository  = each.key
  environment = module.tenant.name
}
