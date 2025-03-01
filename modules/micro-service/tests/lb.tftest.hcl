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

run "validate_lb_defaults" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name

    lb = {
      enabled = true
    }
  }

  # make sure there is only one lbconfig and service params object
  assert {
    condition = (
      length(module.loadbalancer) == 1
    )
    error_message = "There should be one loadbalancer module."
  }

}

# # only do plans here
# run "validate_alb" {
#   command = plan
#   variables {
#     tenant = "dev01"
#     name   = "myapp"

#     lb = {
#       enabled     = true
#       class       = "alb"
#       certificate = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
#     }
#   }

#   # assert the duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].lb_type is 1
#   assert {
#     condition     = duplocloud_duplo_service_lbconfigs.this[0].lbconfigs[0].lb_type == 1
#     error_message = "The lb_type is not set to 1."
#   }
# }
