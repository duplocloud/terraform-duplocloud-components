variable "tenant" {
  description = "The tenant name to scope into. Setting this will output the entire tennant object onto the outputs."
  type        = string
  nullable    = true
  default     = null
}

variable "infra" {
  description = "The name of an infrastructure to get context for. Do not set this if you set a tenant because the tenant will infer the infra. Use this when creating an infra prior to making a tenant."
  type        = string
  nullable    = true
  default     = null

  validation {
    condition = (
      ((var.tenant != null || var.infra != null) &&
      !(var.tenant != null && var.infra != null)) ||
      (var.tenant == null && var.infra == null)
    )
    error_message = "You can either set infra or tenant not both, however neither can be set as well."
  }

  # when just infra is given, you must be admin
  validation {
    condition     = !(var.infra != null && !var.admin)
    error_message = "Only admin level permissions can get infra."
  }
}

variable "admin" {
  description = "Admin level permissions allowed."
  type        = bool
  default     = false
}

variable "jit" {
  description = "Each key determines if the providers jit creds will be outputed."
  type = object({
    aws   = optional(bool, false)
    gcp   = optional(bool, false)
    azure = optional(bool, false)
    k8s   = optional(bool, false)
  })
  default = {}

  # if admin and jit.k8s then the infra or tenant must be set
  validation {
    condition = (
      !(anytrue(values(var.jit)) && !var.admin && var.tenant == null) &&
      !(var.jit.k8s && var.admin && (var.tenant == null && var.infra == null))
    )
    error_message = "When using jit as a non admin, a tenant must be given. An admin must specifiy a tenant or an infra when k8s jit is enabled. AWS, GCP, and Azure do not require a specific tenant or infra when admin."
  }
}

variable "workspaces" {
  description = "A map of workspaces to reference. Each key will be in the outputs with the outputs of that workspace from the state."
  type = map(object({
    name   = optional(string, null)
    prefix = optional(string)
    key    = optional(string)
    nameRef = optional(object({
      workspace = string
      nameKey   = string
    }), null)
  }))
  default  = null
  nullable = true
}
