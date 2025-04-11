variables {
  tenant = "tf-tests"
  name   = "myapp"
  class  = "alb"
}

mock_provider "duplocloud" {
  source = "./tests"
}

run "alb_with_cert_arn" {
  command = plan
  variables {
    tenant      = var.tenant
    name        = var.name
    class       = var.class
    certificate = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  # the cert lookup should be 0 because a cert arn is provided
  assert {
    condition     = length(data.duplocloud_plan_certificate.this) == 0
    error_message = "Expected length(duplocloud_plan_certificate.this) to be 0 but got '${length(data.duplocloud_plan_certificate.this)}'"
  }

  # the local.cert_is_arn should be true
  assert {
    condition     = local.cert_is_arn == true
    error_message = "Expected local.cert_is_arn to be true but got '${local.cert_is_arn}'"
  }

  # the https redirect here should be true
  assert {
    condition = (
      local.https_redirect == true &&
      duplocloud_duplo_service_params.this[0].http_to_https_redirect == true
    )
    error_message = "Expected local.https_redirect to be false but got '${local.https_redirect}'"
  }
}

run "alb_with_govcloud_cert_arn" {
  command = plan
  variables {
    tenant      = var.tenant
    name        = var.name
    class       = var.class
    certificate = "arn:aws-us-gov:acm:us-gov-west-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  # the cert lookup should be 0 because a cert arn is provided
  assert {
    condition     = length(data.duplocloud_plan_certificate.this) == 0
    error_message = "Expected length(duplocloud_plan_certificate.this) to be 0 but got '${length(data.duplocloud_plan_certificate.this)}'"
  }

  # the local.cert_is_arn should be true
  assert {
    condition     = local.cert_is_arn == true
    error_message = "Expected local.cert_is_arn to be true but got '${local.cert_is_arn}'"
  }

  # the https redirect here should be true
  assert {
    condition = (
      local.https_redirect == true &&
      duplocloud_duplo_service_params.this[0].http_to_https_redirect == true
    )
    error_message = "Expected local.https_redirect to be false but got '${local.https_redirect}'"
  }
}

run "lookup_named_cert" {
  command = plan
  variables {
    tenant      = var.tenant
    name        = var.name
    class       = var.class
    certificate = "mycert"
  }

  # the cert lookup should be 0 because a cert arn is provided
  assert {
    condition     = length(data.duplocloud_plan_certificate.this) == 1
    error_message = "Expected length(duplocloud_plan_certificate.this) to be 1 but got '${length(data.duplocloud_plan_certificate.this)}'"
  }

  # The cert is a name not an arn
  assert {
    condition     = local.cert_is_arn == false
    error_message = "Expected local.cert_is_arn to be true but got '${local.cert_is_arn}'"
  }
}

run "basic_alb" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    class  = var.class
  }

  # there should be one lb config
  assert {
    condition     = length(duplocloud_duplo_service_lbconfigs.this) == 1
    error_message = "Expected length(duplocloud_duplo_service_lbconfigs.this) to be 1 but got '${length(duplocloud_duplo_service_lbconfigs.this)}'"
  }

  # there should be one lb params
  assert {
    condition     = length(duplocloud_duplo_service_params.this) == 1
    error_message = "Expected length(duplocloud_duplo_service_params.this) to be 1 but got '${length(duplocloud_duplo_service_params.this)}'"
  }

  # the https redirect here should be false
  assert {
    condition = (
      local.https_redirect == false &&
      duplocloud_duplo_service_params.this[0].http_to_https_redirect == false
    )
    error_message = "Expected local.https_redirect to be false but got '${local.https_redirect}'"
  }
}
