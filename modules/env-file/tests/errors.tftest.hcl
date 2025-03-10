run "no_file_or_content" {
  command = plan
  variables {}
  expect_failures = [ var.file ]
}

run "not_file_and_content" {
  command = plan
  variables {
    file = "./tests/.env"
    content = "FOO=bar"
  }
  expect_failures = [ var.file ]
}
