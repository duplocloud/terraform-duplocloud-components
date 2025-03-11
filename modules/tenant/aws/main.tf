module "tenant" {
  source = "../" 
  infra_name = var.infra_name
  name = var.name
  settings = var.settings
}

module "iam" {
  source = "../../tenant-role-extension"
  tenant_name = var.name 
  policy_name = "${var.name}-custom"
  iam_policy_json = var.policy
}
