mock_provider "duplocloud" {
  source = "../../mocks"
}

run "not_infra_and_parent" {
  command = plan
  variables {
    name       = "cooltenant"
    infra_name = "coolinfra"
    parent     = "shared01"
  }
  expect_failures = [var.parent]
}

run "neither_uses_default" {
  command = plan
  variables {
    name = "cooltenant"
  }
}
