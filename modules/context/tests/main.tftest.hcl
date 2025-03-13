mock_provider "duplocloud" {
  source = "./tests"
}

mock_provider "external" {
  source = "./tests"
}

mock_provider "http" {
  source = "./tests"
}

run "no_tenant_or_infra" {
  command = plan
  variables {}

  assert {
    condition = (
      length(data.duplocloud_tenant.this) == 0 &&
      length(data.duplocloud_infrastructure.this) == 0
    )
    error_message = "There should be no tenant or infra."
  }
}

# make sure the locals host and token are "https://duplo.example.com" and sometoken 
run "check_defaults" {
  command = plan
  variables {}
  assert {
    condition = (
      local.host == "https://duplo.example.com" &&
      local.token == "sometoken"
    )
    error_message = "The host and token should be set correctly."
  }

  assert {
    condition     = local.cloud == "aws"
    error_message = "The cloud should be set to aws."
  }

  assert {
    condition     = !anytrue([for cloud, cred in local.creds : cred != null])
    error_message = "None of the creds should be set by default"
  }

  # by default the tenant and infra in locals sohuld be null
  assert {
    condition     = local.infra == null && local.tenant == null
    error_message = "The infra and tenant should be null by default."
  }
}
