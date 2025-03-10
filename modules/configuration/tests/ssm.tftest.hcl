run "ssm_string" {
  command = plan
  variables {
    tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
    name      = "conf"
    prefix    = "myapp"
    class     = "aws-ssm"
  }

  # make sure we have a unmanaged secret
  assert {
    condition     = length(duplocloud_aws_ssm_parameter.managed) == 1 && length(duplocloud_k8_secret.unmanaged) == 0
    error_message = "There should be no managed secret resource."
  }
  assert {
    condition = duplocloud_aws_ssm_parameter.managed[0].type == "String"
    error_message = "The type of the managed secret should be String."
  }
}

run "ssm_secure" {
  command = plan
  variables {
    tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
    name      = "conf"
    prefix    = "myapp"
    managed   = false
    class     = "aws-ssm-secure"
  }

  # make sure we have a unmanaged secret
  assert {
    condition     = length(duplocloud_aws_ssm_parameter.managed) == 0 && length(duplocloud_aws_ssm_parameter.unmanaged) == 1
    error_message = "There should be an unmanaged ssm resource."
  }
  assert {
    condition = duplocloud_aws_ssm_parameter.unmanaged[0].type == "SecureString"
    error_message = "The type of the managed secret should be String."
  }
}
