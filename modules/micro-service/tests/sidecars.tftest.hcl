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
      name    = "cakes"
      image   = "docker.io/myapp:latest"
      args    = ["sleep", "infinity"]
    }]
  }

  # make sure the additionalContainers key is on the other_docker_config
  assert {
    condition = lookup(local.other_docker_config, "additionalContainers", null) != null
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

}
