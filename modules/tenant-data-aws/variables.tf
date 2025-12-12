variable "tenant_name" {
  description = "Name (not ID) of the tenant."
  type        = string
}

variable "default_certificate_enabled" {
  description = "Is the default certificate enabled in the portal? Usually true."
  default     = true
  type        = bool
}
