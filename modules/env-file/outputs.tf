output "data" {
  value = local.data
}

output "file" {
  value = var.file != null
}

output "content" {
  value = var.content != null
}
