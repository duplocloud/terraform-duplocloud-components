mock_data "duplocloud_tenant" {
  defaults = {
    id      = "c4b717db-a61b-4edc-b895-37c3dfa58fa8"
    name    = "tf-tests"
    plan_id = "myinfra"
  }
}
mock_data "duplocloud_infrastructure" {
  defaults = {
    vpc_name   = "myvpc"
    vpc_id     = "vpc-12345678"
    region     = "us-east-1"
    infra_name = "myinfra"
    account_id = "1234567890"
  }
}

mock_data "duplocloud_plan_certificate" {
  defaults = {
    arn     = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    name    = "mycert"
    plan_id = "myinfra"
  }
}
