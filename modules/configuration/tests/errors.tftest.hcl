variables {
  tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
}

run "no_data_or_value" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    name      = "no-data-or-value"
  }
  expect_failures = [var.data]
}

run "not_data_and_value" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    name      = "data-and-value"
    data = {
      foo = "bar"
    }
    value = "FOO=bar"
  }
  expect_failures = [var.data]
}
