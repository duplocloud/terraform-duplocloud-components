variables {
  tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
  class     = "secret"
  prefix    = "myapp"
  name      = "conf"
  type      = "environment"
  data = {
    FOO = "bar"
  }
}

run "envFrom_output" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    class     = var.class
    prefix    = var.prefix
    name      = var.name
    data      = var.data
    type      = var.type
    managed   = false
  }

  # make sure there is an envFrom output
  assert {
    condition     = output.envFrom != null
    error_message = "There should be an envFrom output."
  }
}
