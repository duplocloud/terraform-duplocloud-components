variables {
  tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
  class     = "secret"
  prefix    = "myapp"
  name      = "conf"
  type      = "environment"
  data = {
    FOO  = "bar"
    CAKE = "chocolate"
  }
  remap = {
    BAZ = "FOO"
    BUZ = "FOO"
  }
}

run "remapping_with_env" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    class     = var.class
    prefix    = var.prefix
    name      = var.name
    data      = var.data
    type      = var.type
    remap     = var.remap
    managed   = false
  }

  # make sure remap is enabled
  assert {
    condition     = local.is_remapped
    error_message = "Is remapped should be true but it is not. 😢"
  }

  # make sure the local remap object looks as it should
  assert {
    condition = local.remap == tomap({
      BAZ  = "FOO"
      BUZ  = "FOO"
      CAKE = "CAKE"
    })
    error_message = "Local remap object does not match expected value."
  }

  # make sure there are exactly three items in the env list from local
  assert {
    condition     = length(local.env) == 3
    error_message = "There should be exactly three items in the env list."
  }
}

run "remapping_but_disabled" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    class     = var.class
    prefix    = var.prefix
    name      = var.name
    data      = var.data
    type      = var.type
    remap     = var.remap
    managed   = false
    enabled   = false
  }

  # make sure remap is enabled
  assert {
    condition     = !local.is_remapped
    error_message = "Is remapped should be false because enabled is false but it is not. 😢"
  }

  # make sure the local remap object looks as it should
  assert {
    condition     = length(local.remap) == 0
    error_message = "When disabled local remap should be empty but it is not."
  }

  # make sure there are exactly three items in the env list from local
  assert {
    condition     = length(local.env) == 0
    error_message = "There should be exactly zero items in the env list."
  }
}
