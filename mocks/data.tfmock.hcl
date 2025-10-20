mock_data "duplocloud_aws_account" {
  defaults = {
    account_id = "123456789012"
  }
}

mock_data "duplocloud_tenant" {
  defaults = {
    id      = "00a03226-7f81-4723-90a1-face65f4278b"
    name    = "shared01"
    plan_id = "nonprod01"
  }
}

mock_data "duplocloud_infrastructure" {
  defaults = {
    infra_name = "nonprod01"
    account_id = "123456789012"
    region     = "us-west-2"
    cloud      = 0
    security_groups = [{
      id   = "sg-0abc1234def567890"
      name = "nonprod01-duplo-allhosts"
    }]
  }
}

mock_data "duplocloud_tenant_internal_subnets" {
  defaults = {
    subnet_ids = [
      "subnet-0123456789abcdef0",
      "subnet-0fedcba9876543210"
    ]
  }
}

mock_data "duplocloud_plan_settings" {
  defaults = {
    plan_id = "nonprod01"
    dns_setting = [{
      external_dns_suffix = ".example.com"
      domain_id           = "Z3P5QSUBK4POTI"
    }]
  }
}

mock_data "duplocloud_plan_certificate" {
  defaults = {
    name    = "wildcard"
    plan_id = "nonprod01"
    arn     = "arn:aws:acm:us-west-2:123456789012:certificate/abcdefg-1234-5678-abcd-ef1234567890"
  }
}

mock_resource "duplocloud_tenant" {
  defaults = {
    tenant_id = "c4b717db-a61b-4edc-b895-37c3dfa58fa8"
    name      = "tf-tests"
    plan_id   = "nonprod01"
  }
}
