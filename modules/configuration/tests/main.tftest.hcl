# only do plans here
run "validate_defaults" {
  command = plan
  variables {
    tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
    data = {}
  }

  # make sure the managed configmap resource has a count of 1
  assert {
    condition     = length(duplocloud_k8_config_map.managed) == 1
    error_message = "The managed configmap resource should have a count of 1."
  }

  # make sure the configuration var looks right
  assert {
    condition     = (
      local.configurations.configmap != null && 
      local.configurations.secret == null && 
      local.configurations.aws-secret == null && 
      local.configurations.aws-ssm == null
    )
    error_message = "The configuration var should be set to myapp."
  }

  # the real name should be myapp
  assert {
    condition     = local.realName == "env"
    error_message = "The real name should just be the default 'env' because type is defaulted to environment."
  }
}
