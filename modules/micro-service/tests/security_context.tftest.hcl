mock_provider "duplocloud" {
  source = "../../mocks"
}

variables {
  tenant = "dev01"
  name   = "myapp"
}

# only do plans here
run "pod_security_context_uses_k8s_camel_case" {
  command = plan
  variables {
    security_context = {
      run_as_user     = 1000
      run_as_group    = 2000
      fs_group        = 3000
      run_as_non_root = true
      seccomp_profile = {
        type = "RuntimeDefault"
      }
    }
  }

  assert {
    condition = local.other_docker_config.PodSecurityContext == {
      runAsUser      = 1000
      runAsGroup     = 2000
      fsGroup        = 3000
      runAsNonRoot   = true
      seccompProfile = { type = "RuntimeDefault" }
    }
    error_message = "PodSecurityContext should use Kubernetes camelCase keys."
  }
}

run "pod_security_context_omitted_when_unset" {
  command = plan
  assert {
    condition     = lookup(local.other_docker_config, "PodSecurityContext", null) == null
    error_message = "PodSecurityContext should not be set when security_context is null."
  }
}

run "container_security_context_uses_k8s_camel_case" {
  command = plan
  variables {
    container_security_context = {
      allow_privilege_escalation = false
      read_only_root_filesystem  = true
      run_as_non_root            = true
      capabilities = {
        drop = ["ALL"]
      }
    }
  }

  assert {
    condition = local.other_docker_config.SecurityContext == {
      allowPrivilegeEscalation = false
      readOnlyRootFilesystem   = true
      runAsNonRoot             = true
      capabilities             = { drop = ["ALL"] }
    }
    error_message = "SecurityContext should use Kubernetes camelCase keys."
  }
}

run "container_security_context_omitted_when_unset" {
  command = plan
  assert {
    condition     = lookup(local.other_docker_config, "SecurityContext", null) == null
    error_message = "SecurityContext should not be set when container_security_context is null."
  }
}

run "sidecar_security_context_uses_k8s_camel_case" {
  command = plan
  variables {
    sidecars = [{
      name  = "cakes"
      image = "docker.io/myapp:latest"
      security_context = {
        run_as_user     = 1000
        run_as_non_root = true
      }
    }]
  }

  assert {
    condition = local.other_docker_config.AdditionalContainers[0].securityContext == {
      runAsUser    = 1000
      runAsNonRoot = true
    }
    error_message = "Sidecar securityContext should use Kubernetes camelCase keys."
  }
}

run "invalid_seccomp_profile_type_rejected" {
  command         = plan
  expect_failures = [var.security_context]
  variables {
    security_context = {
      seccomp_profile = {
        type = "NotARealType"
      }
    }
  }
}

run "localhost_seccomp_profile_without_path_rejected" {
  command         = plan
  expect_failures = [var.security_context]
  variables {
    security_context = {
      seccomp_profile = {
        type = "Localhost"
      }
    }
  }
}

run "non_localhost_seccomp_profile_with_path_rejected" {
  command         = plan
  expect_failures = [var.security_context]
  variables {
    security_context = {
      seccomp_profile = {
        type              = "RuntimeDefault"
        localhost_profile = "profiles/my-profile.json"
      }
    }
  }
}

run "localhost_seccomp_profile_with_path_accepted" {
  command = plan
  variables {
    security_context = {
      seccomp_profile = {
        type              = "Localhost"
        localhost_profile = "profiles/my-profile.json"
      }
    }
  }

  assert {
    condition = local.other_docker_config.PodSecurityContext.seccompProfile == {
      type              = "Localhost"
      localhostProfile  = "profiles/my-profile.json"
    }
    error_message = "PodSecurityContext.seccompProfile should include the localhostProfile path."
  }
}
