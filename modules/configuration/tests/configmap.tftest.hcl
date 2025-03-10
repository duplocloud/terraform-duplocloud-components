run "unmanaged_configmap" {
  command = plan
  variables {
    tenant_id = "2cf9a5bd-311c-47d3-93be-df812e98e775"
    name      = "conf"
    prefix    = "myapp"
    managed   = false
    value = jsonencode({
      FOO = "bar"
    })
  }

  # make sure the managed configmap resource has a count of 1
  assert {
    condition     = length(duplocloud_k8_config_map.managed) == 0
    error_message = "There should be no managed configmap resource."
  }
  assert {
    condition     = length(duplocloud_k8_config_map.unmanaged) == 1
    error_message = "There should be one unmanaged configmap resource."
  }
  # the name should be myapp-conf
  assert {
    condition     = local.name == "myapp-conf"
    error_message = "The name should be myapp-conf."
  }
}
