mock_data "duplocloud_tenant" {
  defaults = {
    id      = "00a03226-7f81-4723-90a1-face65f4278b"
    name    = "shared01"
    plan_id = "nonprod01"
  }
}

mock_resource "duplocloud_tenant" {
  defaults = {
    tenant_id = "c4b717db-a61b-4edc-b895-37c3dfa58fa8"
    name      = "tf-tests"
    plan_id   = "nonprod01"
  }
}
