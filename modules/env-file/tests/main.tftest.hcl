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

run "env_from_content" {
  command = plan
  variables {
    content = "ICE_CREAM=chocolate"
  }

  assert {
    condition = local.data == {
      ICE_CREAM = "chocolate"
    }
    error_message = "The parsed data is incorrect, got ${jsonencode(local.data)}"
  }
}
