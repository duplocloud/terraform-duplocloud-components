run "loading_compose" {
  command = plan
  variables {
    file = "./tests/docker-compose.yaml"
    args = {
      REGISTRY              = "someregistry.com"
      APP                   = "myapp"
      GIT_SHA               = "1234567"
      GIT_REF               = "main"
      AWS_ACCESS_KEY_ID     = ""
      AWS_SECRET_ACCESS_KEY = ""
      AWS_SESSION_TOKEN     = ""
      AWS_REGION            = "us-west-2"
      TENANT_NAME           = "dev01"
      DUPLO_TENANT          = "dev01"
      PORT                  = "80"
    }
  }

  # assert the image was set correctly
  assert {
    condition     = local.docker_compose.services.myapp.image == "someregistry.com/myapp:latest"
    error_message = "The image was not set correctly. Got: ${local.docker_compose.services.myapp.image}"
  }

  # assert the port was set
  assert {
    condition     = local.docker_compose.services.myapp.ports[0] == "8080:80"
    error_message = "The port was not set correctly. Got: ${local.docker_compose.services.myapp.ports[0]}"
  }
}
