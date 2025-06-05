variables {
  tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
}

run "no_data_and_value_when_external" {
  command = plan
  variables {
    tenant_id = var.tenant_id
    name      = "no-data-and-value"
    external  = true
    data = {
      foo = "bar"
    }
  }
  expect_failures = [var.data]
}
