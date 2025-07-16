mock_provider "duplocloud" {
  source = "../../mocks"
}
variables {
  tenant = "dev01"
  name   = "myapp"
}
# only do plans here
run "lifecycles_defaults" {
  command = plan
  variables {
    container_lifecycle = {
      preStop = {
        httpGet = {
          path = "/stopme"
          port = 8080
        }
      }
    }
  }

  # make sure the lifecycle ended up in the config
  assert {
    condition     = lookup(local.other_docker_config, "Lifecycle", null) != null
    error_message = "The lifecycle should be set in the other_docker_config."
  }
}
