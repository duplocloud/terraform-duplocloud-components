mock_provider "duplocloud" {
  source = "./tests"
}

mock_provider "external" {
  source = "./tests"
}

mock_provider "http" {
  source = "./tests"
}

run "infra_only_for_admins" {
  command = plan
  variables {
    infra = "coolinfra"
    admin = false
  }
  expect_failures = [var.infra]
}

run "jit_k8s_admin_needs_infra_or_tenant" {
  command = plan
  variables {
    admin = true
    jit = {
      k8s = true
    }
  }
  expect_failures = [var.jit]
}

run "jit_non_admin_needs_tenant" {
  command = plan
  variables {
    admin = false
    jit = {
      aws = true
    }
  }
  expect_failures = [var.jit]
}

run "not_tenant_and_infra" {
  command = plan
  variables {
    infra  = "coolinfra"
    tenant = "mytenant"
    admin  = true
  }
  expect_failures = [var.infra]
}
