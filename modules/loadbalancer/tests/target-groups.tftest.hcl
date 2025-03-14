mock_provider "duplocloud" {
  source = "./tests"
}

run "target_group" {
  command = plan
  variables {
    tenant   = "tf-tests"
    name     = "myapp"
    class    = "target-group"
    listener = "arn:aws:elasticloadbalancing:us-west-2:123456789012:listener/app/my-load-balancer/50dc6c495c0c9188/0467ef3c5c0885cc"
  }

  assert {
    condition     = length(duplocloud_aws_lb_listener_rule.target-group) == 1
    error_message = "Expected count(duplocloud_aws_lb_listener_rule.this) to be 1 but got '${length(duplocloud_aws_lb_listener_rule.target-group)}'"
  }
}

run "target_group_needs_listener" {
  command = plan
  variables {
    tenant = "tf-tests"
    name   = "myapp"
    class  = "target-group"
    # listener is intentionally omitted to trigger the validation error
  }
  expect_failures = [var.listener]
}
