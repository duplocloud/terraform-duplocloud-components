mock_provider "duplocloud" {
  source = "../../mocks"
}
variables {
  tenant = "dev01"
  name   = "myapp"
}
# only do plans here
run "enable_health_checks" {
  command = plan
  variables {
    health_check = {
      enabled             = true
      path                = "/health"
      initialDelaySeconds = 10
      periodSeconds       = 5
      failureThreshold    = 3
      successThreshold    = 1
      timeoutSeconds      = 2
    }
  }
  # make sure the healthchecks are added to the service
  assert {
    condition     = lookup(local.other_docker_config, "LivenessProbe", null) != null
    error_message = "The LivenessProbe should be added to the service."
  }

  assert {
    condition     = lookup(local.other_docker_config, "ReadinessProbe", null) != null
    error_message = "The ReadinessProbe should be added to the service."
  }

  assert {
    condition     = lookup(local.other_docker_config, "StartupProbe", null) != null
    error_message = "The StartupProbe should be added to the service."
  }

}

run "debug_mode_health_checks" {
  command = plan
  variables {
    debug = true
    health_check = {
      enabled             = true
      path                = "/health"
      initialDelaySeconds = 10
      periodSeconds       = 5
      failureThreshold    = 3
      successThreshold    = 1
      timeoutSeconds      = 2
    }
  }
  # make sure the healthchecks are not added to the service
  assert {
    condition     = lookup(local.other_docker_config, "LivenessProbe", null) == null
    error_message = "The LivenessProbe should be null."
  }
  assert {
    condition     = lookup(local.other_docker_config, "ReadinessProbe", null) == null
    error_message = "The ReadinessProbe should be null."
  }
  assert {
    condition     = lookup(local.other_docker_config, "StartupProbe", null) == null
    error_message = "The StartupProbe should be null."
  }

  # make sure we got the tail to black hole command and args because debug is true
  assert {
    condition     = local.other_docker_config.Command == ["/bin/sh", "-c"]
    error_message = "The Command should be set to tail to black hole."
  }
  assert {
    condition     = local.other_docker_config.Args == ["tail -f /dev/null"]
    error_message = "The Args should be set to tail to black hole."
  }

}
