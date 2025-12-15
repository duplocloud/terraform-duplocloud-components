variable "tenant_name" {
  description = "Name (not ID) of the tenant."
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "default_certificate_enabled" {
  description = "DEPRECATED"
  default     = true
  type        = bool
}
