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
    managed = false
  }

  # make sure there is an envFrom output
  assert {
    condition     = output.envFrom != null
    error_message = "There should be an envFrom output."
  }

  # is_remapped should be false here
  assert {
    condition     = local.is_remapped == false
    error_message = "Is remapped should be false but it is not. 😢"
  }

  # make sure there are no env vars because this is envFrom style
  assert {
    condition     = length(local.env) == 0
    error_message = "There should be exactly zero items in the env list."
  }

  # there should be a resource when external is false
  assert {
    condition     = local.resource != null
    error_message = "There should be a resource when external is false."
  }
}

run "external_envFrom" {
  command = plan
  variables {
    external = true
    data     = null
    value    = null
  }

  # make sure there is an envFrom output
  assert {
    condition     = output.envFrom != null
    error_message = "There should be an envFrom output."
  }

  # the local resource variable should be null
  assert {
    condition     = local.resource == null
    error_message = "The local resource should be null when external is true."
  }
}
