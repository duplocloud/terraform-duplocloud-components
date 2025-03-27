locals {
  data  = var.data != null ? var.data : {}
  value = var.value != null ? var.value : jsonencode(local.data)
}


