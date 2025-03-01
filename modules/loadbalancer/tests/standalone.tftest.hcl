run "standalone_alb" {
  command = plan
  variables {
    tenant = "tf-tests"
    name      = "myapp"
    class    = "standalone-alb"
  }

  # assert the local.is_standalone is true
  assert {
    condition = local.is_standalone == true
    error_message = "Expected local.is_standalone to be true but got false"
  }

  assert {
    condition = (
      length(duplocloud_aws_load_balancer.this) == 1 &&
      length(duplocloud_aws_lb_target_group.this) == 1 &&
      length(duplocloud_aws_load_balancer_listener.default) == 1 &&
      length(duplocloud_aws_lb_listener_rule.default) == 1
    )
    error_message = "Expected count(duplocloud_aws_lb_listener_rule.this) to be 1 but got something else"
  }
}
