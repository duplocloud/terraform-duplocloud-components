mock_provider "duplocloud" {
  source = "./tests"
}

run "no_grantee_or_parent" {
  command = plan
  variables {
    name = "cooltenant"
    grants = [{
      area = "s3"
    }]
  }
  expect_failures = [var.grants]
}
