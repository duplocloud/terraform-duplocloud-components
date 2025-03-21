variable "name" {
  description = "The name of the tenant"
  type        = string
  nullable    = true
  default     = null
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
At least a `to_port` is required. The `from_port` will default to the `to_port` if not specified. If a `source_tenant` is not specified, then this rule will be created in the parent tenant to allow this tenant to use a certain port. IF the `source_tenant` is specified then the rule is created in this tenant to allow another tenant to access a certain port. 
EOT
  type = list(object({
    description    = optional(string, null)
    protocol       = optional(string, "tcp")
    from_port      = optional(number, null)
    source_tenant  = optional(string, null)
    source_address = optional(string, null)
    to_port        = number
  }))
  default = []
  validation {
    condition = !(
      var.parent == null && anytrue([
        for rule in var.sg_rules : (
          rule.source_tenant == null &&
          rule.source_address == null
        )
      ])
    )
    error_message = "Parent must be set if rules are defined."
  }
}

variable "grants" {
  description = <<EOT
Grants use of resources from the parent tenant or allow other tenants to use from this one. If a grantee is specified, then the grantor is this tenant. If a grantee is not specified, then the grantor is the parent tenant and a parent must be set.
EOT
  type = set(object({
    area    = string
    grantee = optional(string, null)
  }))
  default = []

  # area can be one of s3, dynamodb, or kms
  validation {
    condition = !anytrue([
      for grant in var.grants : !contains(["s3", "dynamodb", "kms"], grant.area)
    ])
    error_message = "The area must be one of the following: s3, dynamodb, kms."
  }

  validation {
    condition = !(
      var.parent == null && anytrue([
        for grant in var.grants : grant.grantee == null
      ])
    )
    error_message = <<EOT
Parent must be set if any grantees are not defined. 
When a grantee is not defined, the parent is assumed as the grantor and this tenant as the grantee and therefor and parent is needed.
EOT
  }
}

variable "settings" {
  description = "The settings to apply to the tenant"
  type        = map(string)
  default     = null
  nullable    = true
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
