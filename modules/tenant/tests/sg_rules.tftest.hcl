mock_provider "duplocloud" {
  source = "../../mocks"
}

run "no_source_tenant_nor_address_nor_parent" {
  command = plan
  variables {
    name = "cooltenant"
    security_rules = [{
      to_port = 80
    }]
  }
  expect_failures = [var.security_rules]
}

run "egress_with_parent" {
  command = plan
  # override_data {
  #   target = data.duplocloud_tenant.parent[0]
  #   values = {
  #     id      = "00a03226-7f81-4723-90a1-face65f4278b"
  #     name    = "shared01"
  #     plan_id = "nonprod01"
  #   }
  # }
  variables {
    name   = "cooltenant"
    parent = "shared01"
    security_rules = [{
      to_port = 80
    }]
  }

  assert {
    condition     = length(duplocloud_tenant_network_security_rule.this) == 1
    error_message = "There should be at least one sg rule"
  }

  # make sure the first key is like "${rule.type}-${rule.to_port}-${rule.protocol}"
  assert {
    condition     = keys(duplocloud_tenant_network_security_rule.this)[0] == "parent-80-tcp"
    error_message = "There should be a key like egress-80-tcp"
  }

  # check the parent id is the tenant_id of the rule
  assert {
    condition     = duplocloud_tenant_network_security_rule.this["parent-80-tcp"].tenant_id == "00a03226-7f81-4723-90a1-face65f4278b"
    error_message = "The tenant_id should be the parent id"
  }
}
