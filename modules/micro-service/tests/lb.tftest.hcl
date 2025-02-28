run "validate_lb_defaults" {
  command = plan
  variables {
    tenant = "dev01"
    name   = "myapp"

    lb = {
      enabled = true
    }
  }

  # make sure there is only one lbconfig and service params object
  assert {
    condition = (
      length(duplocloud_duplo_service_lbconfigs.this) == 1 &&
      length(duplocloud_duplo_service_params.this) == 1
    )
    error_message = "There should be only one lbconfig object."
  }

  # make sure the type was set correctly from the mapping
  assert {
    condition     = duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].lb_type == 3
    error_message = "The lb_type is not set to 3."
  }
}

# only do plans here
run "validate_alb" {
  command = plan
  variables {
    tenant = "dev01"
    name   = "myapp"

    lb = {
      enabled     = true
      class       = "alb"
      certificate = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    }
  }

  # assert the duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].lb_type is 1
  assert {
    condition     = duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].lb_type == 1
    error_message = "The lb_type is not set to 1."
  }
}
