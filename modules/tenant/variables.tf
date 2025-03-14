variable "name" {
  description = "The name of the tenant"
  type        = string
}

variable "infra_name" {
  description = "The name of the infrastructure to use"
  type        = string
  nullable    = true
  default     = null
}

variable "parent" {
  description = "The name of a parent tenant to infer infrastructure from and share services with. This value is mutually exclusive with infra_name."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition = !(
      var.parent != null && var.infra_name != null
    )
    error_message = "parent and infra_name are mutually exclusive. Using parent will infer the infrastructure."
  }
}

variable "sg_rules" {
  description = <<EOT
A list of security group rules to apply to the tenant.
The `type` field can be either `ingress` or `egress`. An ingress means you are exposing some service within this tenant to another tenant or IP. An egress means you are allowing this tenant to access some service in another tenant or IP. If the type is egress, you can only make rules with the parent tenant, and therefore var.parent must be set. 
EOT
  type = list(object({
    type           = optional(string, "ingress")
    description    = optional(string, null)
    protocol       = optional(string, "tcp")
    from_port      = optional(number, null)
    source_tenant  = optional(string, null)
    source_address = optional(string, null)
    to_port        = number
  }))
  default = []
  validation {
    condition = !(var.parent == null && anytrue([
      for rule in var.sg_rules : rule.type == "egress"
    ]))
    error_message = "Parent must be set if any egress rules are defined."
  }
  # if the type is ingress either source_tenant or source_address must be set
  validation {
    condition = !anytrue([
      for rule in var.sg_rules : rule.type == "ingress" && (rule.source_tenant == null && rule.source_address == null)
    ])
    error_message = "For ingress rules, either source_tenant or source_address must be set."
  }
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
