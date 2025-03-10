locals {
  # The contents of the .env file
  content = var.content != null ? var.content : file(var.file)

  # Split the content by new lines, skip the comment lines and empty lines
  split_lines = [
    for line in split("\n", trimspace(local.content)) : trimprefix(line, "export ")
    if(length(line) > 0 && !startswith(line, "#"))
  ]

  # Pattern to capture key and value with or without quotes
  kv_pattern = "^(\\w+)=['\"]?(.*?)['\"]?$"

  # Process lines using regexall to separate key and value
  key_value_pairs = [
    for line in local.split_lines :
    length(regexall(local.kv_pattern, line)) > 0 ?
    {
      key   = regexall(local.kv_pattern, line)[0][0],
      value = regexall(local.kv_pattern, line)[0][1]
    }
    : null
  ]

  # Filter out nulls (in case there are invalid lines)
  # data = [for pair in local.key_value_pairs : pair if pair != null]
  data = {
    for pair in local.key_value_pairs : pair.key => pair.value
    if pair != null
  }
}

# check "content" {
#   assert {
#     condition = (
#       (var.content != null || var.file != null) &&
#       !(var.content != null && var.file != null)
#     )
#     error_message = "Either file or content must be set, but not both."
#   }
# }
