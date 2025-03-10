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
    data      = {
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
