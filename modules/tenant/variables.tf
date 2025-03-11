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

variable "configurations" {
  description = <<EOT
  The contained configurations for this tenant. 

  See the [duplocloud/components/configuration](https://registry.terraform.io/modules/duplocloud/components/duplocloud/latest/submodules/configuration) module on the registry for more information about the details of the objects. 
  EOT
  type = list(object({
    enabled     = optional(bool, true)
    class       = optional(string, "configmap")
    external    = optional(bool, false)
    name        = optional(string, null)
    description = optional(string, null)
    type        = optional(string, "environment") # environment or file
    data        = optional(map(string), {})
    value       = optional(string, null)
    managed     = optional(bool, true)
    csi         = optional(bool, false)
    mountPath   = optional(string, null)
  }))
  default = []
}
