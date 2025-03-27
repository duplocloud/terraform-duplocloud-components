mock_provider "duplocloud" {
  source = "./tests"
}

run "validate_defaults" {
  command = plan
  variables {
    tenant = "tf-tests"
    name   = "myapp"
  }

  # assert local.class is the value service
  assert {
    condition     = local.class == "service"
    error_message = "Expected local.class to be 'service' but got '${local.class}'"
  }

  # assert is_ingress is false
  assert {
    condition     = local.is_ingress == false
    error_message = "Expected local.is_ingress to be false but got '${local.is_ingress}'"
  }

  # make sure lbconfig_needed is true by default
  assert {
    condition     = local.lbconfig_needed == true
    error_message = "Expected local.lbconfig_needed to be true but got '${local.lbconfig_needed}'"
  }

  # by default the count of duplocloud_aws_lb_listener_rule should be 0
  assert {
    condition     = length(duplocloud_aws_lb_listener_rule.target-group) == 0
    error_message = "Expected count(duplocloud_aws_lb_listener_rule.target-groups) to be 0 but got '${length(duplocloud_aws_lb_listener_rule.target-group)}'"
  }

  # there is no cert so no lookup should be done
  assert {
    condition = (
      local.cert_is_arn == false &&
      local.do_cert_lookup == false &&
      local.cert_arn == null
    )
    error_message = "Expected local.cert_arn to be null but got"
  }

  # make sure the default dns_prfx is app name - tenant name
  assert {
    condition     = local.dns_prfx == "myapp-tf-tests"
    error_message = "Expected local.dns_prfx to be 'myapp-tf-tests' but got '${local.dns_prfx}'"
  }

  # make sure the duplocloud_plan_certificate length is 0
  assert {
    condition     = length(data.duplocloud_plan_certificate.this) == 0
    error_message = "Expected length(duplocloud_plan_certificate.this) to be 0 but got '${length(data.duplocloud_plan_certificate.this)}'"
  }

  # the ingress annotations should be null
  assert {
    condition     = local.ingress_annotations == null
    error_message = "Expected local.ingress_annotations to be null"
  }
}
