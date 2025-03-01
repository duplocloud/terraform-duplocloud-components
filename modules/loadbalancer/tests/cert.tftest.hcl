variables {
  tenant = "tf-tests"
  name      = "myapp"
  class    = "alb"
}

mock_provider "duplocloud" {
  mock_data "duplocloud_tenant" {
    defaults = {
      id      = "c4b717db-a61b-4edc-b895-37c3dfa58fa8"
      name    = "tf-tests"
      plan_id = "myinfra"
    }
  }
  mock_data "duplocloud_plan_certificate" {
    defaults = {
      arn     = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
      name    = "mycert"
      plan_id = "myinfra"
    }
  }
}

run "no_cert_lookup_when_arn" {
  command = plan
  variables {
    tenant = var.tenant
    name      = var.name
    class    = var.class
    certificate = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  # the cert lookup should be 0 because a cert arn is provided
  assert {
    condition = length(data.duplocloud_plan_certificate.this) == 0
    error_message = "Expected length(duplocloud_plan_certificate.this) to be 0 but got '${length(data.duplocloud_plan_certificate.this)}'"
  }

  # the local.cert_is_arn should be true
  assert {
    condition = local.cert_is_arn == true
    error_message = "Expected local.cert_is_arn to be true but got '${local.cert_is_arn}'"
  }
}

run "lookup_named_cert" {
  command = plan
  variables {
    tenant = var.tenant
    name      = var.name
    class    = var.class
    certificate = "mycert"
  }

  # the cert lookup should be 0 because a cert arn is provided
  assert {
    condition = length(data.duplocloud_plan_certificate.this) == 1
    error_message = "Expected length(duplocloud_plan_certificate.this) to be 1 but got '${length(data.duplocloud_plan_certificate.this)}'"
  }

  # The cert is a name not an arn
  assert {
    condition = local.cert_is_arn == false
    error_message = "Expected local.cert_is_arn to be true but got '${local.cert_is_arn}'"
  }
}
