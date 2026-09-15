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

run "tcp_socket_health_checks" {
  command = plan
  variables {
    port = 8080
    health_check = {
      enabled = true
      type    = "tcp"
    }
  }

  # all three probes should use tcpSocket with the service port, not httpGet
  assert {
    condition     = local.other_docker_config.LivenessProbe.tcpSocket == { port = 8080 }
    error_message = "The LivenessProbe should use tcpSocket on the service port."
  }
  assert {
    condition     = !contains(keys(local.other_docker_config.LivenessProbe), "httpGet")
    error_message = "The LivenessProbe should not have httpGet when type is tcp."
  }
  assert {
    condition     = local.other_docker_config.ReadinessProbe.tcpSocket == { port = 8080 }
    error_message = "The ReadinessProbe should use tcpSocket on the service port."
  }
  assert {
    condition     = local.other_docker_config.StartupProbe.tcpSocket == { port = 8080 }
    error_message = "The StartupProbe should use tcpSocket on the service port."
  }
}

run "tcp_socket_override_per_probe" {
  command = plan
  variables {
    port = 8080
    health_check = {
      enabled = true
      type    = "http"
      readiness = {
        type = "tcp"
        port = 9090
      }
    }
  }

  # liveness/startup should stay httpGet (inherit top-level type), readiness overrides to tcpSocket
  assert {
    condition     = contains(keys(local.other_docker_config.LivenessProbe), "httpGet")
    error_message = "The LivenessProbe should use httpGet when the top-level type is http."
  }
  assert {
    condition     = local.other_docker_config.ReadinessProbe.tcpSocket == { port = 9090 }
    error_message = "The ReadinessProbe should override to tcpSocket on its own port."
  }
  assert {
    condition     = contains(keys(local.other_docker_config.StartupProbe), "httpGet")
    error_message = "The StartupProbe should use httpGet when the top-level type is http."
  }
}

run "invalid_health_check_type_rejected" {
  command         = plan
  expect_failures = [var.health_check]
  variables {
    health_check = {
      type = "udp"
    }
  }
}

run "grpc_health_checks_default_service" {
  command = plan
  variables {
    port = 9000
    health_check = {
      enabled = true
      type    = "grpc"
    }
  }

  # grpc probes with no grpc_service set should omit the service key (checks the default gRPC service)
  assert {
    condition     = local.other_docker_config.LivenessProbe.grpc == { port = 9000 }
    error_message = "The LivenessProbe should use a grpc probe on the service port with no service key."
  }
  assert {
    condition     = local.other_docker_config.ReadinessProbe.grpc == { port = 9000 }
    error_message = "The ReadinessProbe should use a grpc probe on the service port with no service key."
  }
  assert {
    condition     = local.other_docker_config.StartupProbe.grpc == { port = 9000 }
    error_message = "The StartupProbe should use a grpc probe on the service port with no service key."
  }
}

run "grpc_health_checks_with_service_override" {
  command = plan
  variables {
    port = 9000
    health_check = {
      enabled      = true
      type         = "grpc"
      grpc_service = "myapp.Health"
      readiness = {
        port         = 9001
        grpc_service = "myapp.Readiness"
      }
    }
  }

  assert {
    condition     = local.other_docker_config.LivenessProbe.grpc == { port = 9000, service = "myapp.Health" }
    error_message = "The LivenessProbe should use the top-level grpc_service."
  }
  assert {
    condition     = local.other_docker_config.ReadinessProbe.grpc == { port = 9001, service = "myapp.Readiness" }
    error_message = "The ReadinessProbe should override port and grpc_service independently."
  }
}
