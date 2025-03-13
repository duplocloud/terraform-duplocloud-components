data "terraform_remote_state" "this" {
  for_each  = local.workspaces
  backend   = "s3"
  workspace = each.value.name
  config = {
    bucket               = local.tfstate_bucket
    region               = local.default_region
    workspace_key_prefix = each.value.prefix
    key                  = each.value.key
  }
}
