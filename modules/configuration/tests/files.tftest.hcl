variables {
  tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
  name      = "conf"
  prefix    = "myapp"
  type      = "files"
}

# only do plans here
run "files_with_no_csi" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    name      = var.name
    prefix    = var.prefix
    type      = var.type
    managed   = false
    csi       = false
    class     = "aws-ssm"
    value     = <<EOF
    self_destruct = heck yeah
    EOF

  }
  # the volume output should be null with this configuration
  assert {
    condition     = output.volume == null
    error_message = "The volume output should be null with this configuration."
  }

  # there whould be no envFrom or env in the locals
  assert {
    condition     = length(local.envFrom) == 0 && length(local.env) == 0
    error_message = "There should be no envFrom or env output when type is files."
  }
}
run "files_with_csi_environment" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    name      = var.name
    prefix    = var.prefix
    type      = var.type
    csi       = true
    class     = "aws-secret"
    data = {
      "myapp.conf" = <<EOF
      a_setting="never set this"
      EOF
    }
  }
  # the volume output should be null with this configuration
  assert {
    condition     = output.volume != null
    error_message = "The volume output should be null with this configuration."
  }
}

run "files_with_remapping" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    name      = var.name
    prefix    = var.prefix
    type      = var.type
    class     = "configmap"
    mountPath = "/etc/myapp"
    data = {
      "myapp.conf" = <<EOF
      a_setting="never ever set this or else 🐉"
      EOF
    }
    remap = {
      "somefile.env" = "myapp.conf"
    }
  }
  # the volume should not be null with this configuration
  assert {
    condition     = output.volume != null
    error_message = "The volume output should not be null with this configuration."
  }

  # make sure the first volume mount has a subpath to the original file name in the data and check the mountPath is correct 
  assert {
    condition = (
      length(local.volumeMounts) == 1 &&
      local.volumeMounts[0].subPath == "myapp.conf" &&
      local.volumeMounts[0].mountPath == "/etc/myapp/somefile.env"
    )
    error_message = "There should be one volume mount with a subPath to the original file name in the data."
  }
}
