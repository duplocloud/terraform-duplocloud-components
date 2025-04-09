data "terraform_remote_state" "refs" {
  for_each = {
    for name, workspace in local.workspaces : name => workspace
    if workspace.nameRef == null
  }
  backend   = local.backend
  workspace = each.value.name
  config    = each.value.backend
}

data "terraform_remote_state" "namerefs" {
  for_each = {
    for name, workspace in local.workspaces : name => workspace
    if workspace.nameRef != null
  }
  backend   = local.backend
  workspace = data.terraform_remote_state.refs[each.value.nameRef.workspace].outputs[each.value.nameRef.nameKey]
  config    = each.value.backend
}
