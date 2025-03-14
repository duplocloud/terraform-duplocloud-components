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


variable "policy" {
  description = "The policy to apply to the tenant"
  type        = string
  default     = null
  nullable    = true
}

variable "repos" {
  description = <<EOT
A list of Github repository names. 
Each one will get a new environment matching the name of the tenant.
EOT
  type        = list(string)
  default     = []
}
