variable "name" {
  description = "The name of the tenant"
  type        = string
}

variable "infra_name" {
  description = "The name of the infrastructure to use"
  type        = string
}

variable "settings" {
  description = "The settings to apply to the tenant"
  type        = map(string)
  default     = {}
}

variable "policy" {
  description = "The policy to apply to the tenant"
  type        = string
  default     = ""
}
