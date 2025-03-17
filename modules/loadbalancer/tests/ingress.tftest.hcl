mock_provider "duplocloud" {
  source = "./tests"
}

run "ingress_alb" {
  command = plan
  variables {
    tenant = "tf-tests"
    name   = "myapp"
    class  = "ingress-alb"
  }

  # assert the local.is_standalone is true
  assert {
    condition = (
      local.is_standalone == false &&
      local.is_ingress == true
    )
    error_message = "Expected local.is_ingress to be true and standalone to be false"
  }

  # assert that the local.ingress_class is set to "alb"
  assert {
    condition = (
      local.ingress_class == "alb" &&
      local.class == "service"
    )
    error_message = "Expected local.ingress_class to be alb but got something else"
  }

  assert {
    condition = (
      length(duplocloud_k8_ingress.this) == 1
    )
    error_message = "Expected count(duplocloud_aws_lb_listener_rule.this) to be 1 but got something else"
  }

  # the annotations should be set
  assert {
    condition = (
      local.ingress_annotations != null &&
      local.ingress_annotations["kubernetes.io/ingress.class"] == "alb"
    )
    error_message = "Expected local.ingress_annotations to be null"
  }
}
