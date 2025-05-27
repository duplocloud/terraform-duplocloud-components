# only do plans here
run "validate_name" {
  command = plan
  variables {
    tenant_id = "c4b717db-a61b-4edc-b895-37c3dfa58fa8"
  }
  assert {
    condition     = duplocloud_asg_profile.nodes.friendly_name == "apps"
    error_message = "friendly_name is not apps"
  }
}
