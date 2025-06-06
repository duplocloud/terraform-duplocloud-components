mock_provider "duplocloud" {
  source = "../../mocks"
}

# only do plans here
run "adds_sidecars" {
  command = plan
  variables {
    tenant  = "dev01"
    name    = "myapp"
    command = ["npm"]
    sidecars = [{
      name  = "cakes"
      image = "docker.io/myapp:latest"
      args  = ["sleep", "infinity"]
      env = {
        FOO = "bar"
      }
    }]
  }

  # make sure the additionalContainers key is on the other_docker_config
  assert {
    condition     = lookup(local.other_docker_config, "additionalContainers", null) != null
    error_message = "There should be additionalContainers in the other_docker_config."
  }

  # make sure there is exactly one sidecar and it has the right name
  assert {
    condition = (
      length(local.other_docker_config.additionalContainers) == 1 &&
      local.other_docker_config.additionalContainers[0].name == "cakes"
    )
    error_message = "There should be one sidecar with the name 'cakes'."
  }

  # make sure there is no command key on the sidecar but there is args, this proves the if statements in the template are working
  assert {
    condition = (
      !contains(keys(local.other_docker_config.additionalContainers[0]), "command") &&
    contains(keys(local.other_docker_config.additionalContainers[0]), "args"))
    error_message = "There should not be a command key on the sidecar and there should be args."
  }

  # make sure the env key is on additionalContainers and it has the right value
  assert {
    condition = (
      contains(keys(local.other_docker_config.additionalContainers[0]), "env") &&
      local.other_docker_config.additionalContainers[0].env == [{
        name  = "FOO",
        value = "bar"
      }]
    )
    error_message = "There should be an env key on the sidecar with the right value."
  }

}
