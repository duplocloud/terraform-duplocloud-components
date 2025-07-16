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
  description = <<EOT
Each key determines if the providers jit creds will be outputed.
When one of these are true, then the actual credentials are sent to the output under the same key. 
So if aws here is true, then JIT AWS credentials will all be under the ouptut object `module.ctx.jit.aws`.
EOT
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
  description = <<EOT
A map of workspaces to reference. Each key will be in the outputs of this module with the outputs of that workspace from the state as the value. See the same key in the outputs of this module for details on how to access outputs from these workspaces. 

`name`: The name of the remote workspace. This will default to `terraform.workspace` if not set.
`prefix`: The prefix to use for the remote workspace. This is only relevant for AWS S3 backends and is basically the folder for the module. This will default to the `key` if not set.
`key`: The name of the key in the storage. This is basically the name of the TF State File. This value defaults to the actual key for this object in the map of workspaces.  
`nameRef`: Use this when you can't know the `name` of the workspace until another workspaces first resolves and outputs the unknown name. For example, you know the tenant name but not the infra name but you know the tenant module outputs the infra name on the `infra_name` key in the ouptuts. In this case you can set the `nameRef.workpsace` to the value `tenant` because that is a key in the workspaces map. Then we can set the `nameRef.nameKey` to the value `infra_name` because that output is the actual name of the infra based on the outputs of the tenant. 
EOT
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

variable "state_bucket" {
  description = <<EOT
The name of the state bucket if it's different than the default one which came with the portal.
This is not needed if the System Setting 'StateBucket' is set.
In most cases this value is null as the bucket name is predetermined.
EOT
  type        = string
  nullable    = true
  default     = null
}
