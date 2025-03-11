# only do plans here
run "validate_defaults" {
  command = plan
  variables {
    tenant = "dev01"
    name   = "myapp"
  }
  # check that the image uri is defaulted correctly
  assert {
    condition     = local.image_uri == "docker.io/myapp:latest"
    error_message = "The image was not set on the service correctly."
  }

  # make sure var.lb.port is null
  assert {
    condition     = var.lb.port == null
    error_message = "The lb port was not set to null."
  }

  assert {
    condition     = length(duplocloud_k8s_job.before_update) == 0
    error_message = "There should be no before update job by default."
  }

  # make sure the local.env_from is an empty array by default
  assert {
    condition     = length(local.env_from) == 0
    error_message = "The env_from should be an empty array by default."
  }

  # # make sure there are no lb objects created
  # assert {
  #   condition = (
  #     length(duplocloud_duplo_service_lbconfigs.this) == 0 &&
  #     length(duplocloud_duplo_service_params.this) == 0
  #   )
  #   error_message = "There should be only one lbconfig object."
  # }
}
