variables {
  tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
  class     = "secret"
  prefix    = "myapp"
  name      = "conf"
  data = {
    FOO = "bar"
  }
}

run "unmanaged_secret" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    class     = var.class
    prefix    = var.prefix
    name      = var.name
    data      = var.data
    managed   = false
  }

  # make sure we have a unmanaged secret
  assert {
    condition     = length(duplocloud_k8_secret.managed) == 0 && length(duplocloud_k8_secret.unmanaged) == 1
    error_message = "There should be no managed secret resource."
  }
}

# now do the same for managed secrets
run "managed_secret" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    class     = var.class
    prefix    = var.prefix
    name      = var.name
    data      = var.data
    managed   = true
  }

  # make sure we have a managed secret
  assert {
    condition     = length(duplocloud_k8_secret.managed) == 1 && length(duplocloud_k8_secret.unmanaged) == 0
    error_message = "There should be one managed secret resource."
  }
}
