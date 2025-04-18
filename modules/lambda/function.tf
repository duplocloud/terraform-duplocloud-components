resource "duplocloud_aws_lambda_function" "this" {
  tenant_id   = local.tenant_id
  name        = var.name
  description = var.description

  package_type = var.package_type
  image_uri    = var.image.uri

  image_config {
    command           = [var.handler]
    entry_point       = var.image.entry_point
    working_directory = var.image.working_directory
  }

  tracing_config {
    mode = var.tracing_mode
  }

  timeout     = var.timeout
  memory_size = var.memory_size
  environment { variables = var.environment }
  lifecycle {
    ignore_changes = [architectures]
  }

}
