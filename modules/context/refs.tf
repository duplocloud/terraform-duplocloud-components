data "terraform_remote_state" "refs" {
  for_each = {
    for name, workspace in local.workspaces : name => workspace
    if workspace.nameRef == null
  }
  backend   = "s3"
  workspace = each.value.name
  config = {
    bucket               = local.tfstate_bucket
    region               = local.default_region
    workspace_key_prefix = each.value.prefix
    key                  = each.value.key
  }
}

data "terraform_remote_state" "namerefs" {
  for_each = {
    for name, workspace in local.workspaces : name => workspace
    if workspace.nameRef != null
  }
  backend   = "s3"
  workspace = data.terraform_remote_state.refs[each.value.nameRef.workspace].outputs[each.value.nameRef.nameKey]
  config = {
    bucket               = local.tfstate_bucket
    region               = local.default_region
    workspace_key_prefix = each.value.prefix
    key                  = each.value.key
  }
}
