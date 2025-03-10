run "parsing_env_files" {
  command = plan
  variables {
    file = "./tests/.env"
  }

  assert {
    condition = local.data == {
      FOO      = "bar"
      MESSAGE  = "Hello, world!"
      NAME     = "John Doe"
      PASSWORD = "complexPassword123"
    }
    error_message = "The parsed data is incorrect, got ${jsonencode(local.data)}"
  }

}
