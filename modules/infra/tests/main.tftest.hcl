run "just_nothing" {
  command = plan
  variables {}
  assert {
    condition     = var.class == "duplocloud"
    error_message = "The class must be 'duplocloud' if nothing is set."
  }
}
