variable "tenant_id" {
  description = "The tenant id."
  type        = string
}

variable "name" {
  description = "The simple name of the config. This name is used on volumes/volumeMounts as the name."
  type        = string
  default     = null
  nullable    = true
}

variable "prefix" {
  description = "An optional prefix for the name with a dash. This is ideal if the name comes from the higher level resource/module, e.g. the app name."
  type        = string
  default     = null
  nullable    = true
}

variable "description" {
  description = "The description of the configuration."
  type        = string
  default     = null
  nullable    = true
}

variable "type" {
  description = <<EOT
Infers how this configuration will be used. Each type describes different ways the configuration will be mounted into the service and how the app expects to receive these values.

Types:  
`environment` - This means each key in the data is an anvironment variable name and the value is the value of the environment variable. This will be mounted as an envFrom on the container. This is the default type.
`files` - This means each key in the data is a file name and the value is the content of the file. This will be mounted as a volume and volumeMount on the container. The mountPath can be used with this type.
`reference` - This means your code is expecting the name of the configuration to be passed in as an environment variable and your code will look up the values on it's own. The default name of the environment variable is CONFIG_NAME, but you can override this with the `remap` variable like CONFIG_NAME = "MY_SECRET". 
EOT
  type        = string
  default     = "environment" # or files
  # make sure the value is one of the accepted values
  validation {
    condition = contains([
      "environment", "files", "reference"
    ], var.type)
    error_message = "The type must be one of the following: environment, files, or reference."
  }
}

variable "class" {
  description = "The class of the config."
  type        = string
  default     = "configmap"

  # make sure the value is one of the accepted values
  validation {
    condition = contains([
      "configmap", "secret",
      "aws-secret", "aws-ssm",
      "aws-ssm-secure", "aws-ssm-list",
      "gcp-secret"
    ], var.class)
    error_message = "The class must be one of the following: configmap, secret."
  }
}

variable "external" {
  description = <<EOT
Set to true if the underlying configuration resource, like a configmap or secret, is managed outside of this module. This will not create the resource, but will still create the volume and volumeMounts.

Warning: This is not implemented quite yet. 
EOT
  type        = bool
  default     = false
}

variable "csi" {
  description = "Whether to use the csi driver and bind to a kubernetes secret. Only available for aws-secret and aws-ssm."
  type        = bool
  default     = false
}

variable "managed" {
  description = "Whether terraform should manage the value of the data. If false, the data will be ignored."
  type        = bool
  default     = true
}

variable "enabled" {
  description = "Whether the configuration is enabled on a service."
  type        = bool
  default     = true
}

variable "mountPath" {
  description = "The mount path of the configuration. Only available for files and when csi is enabled."
  type        = string
  default     = null
  nullable    = true
}

variable "data" {
  description = "The map of key/values for the configuration."
  type        = map(string)
  default     = null
  nullable    = true
  validation {
    condition = (
      # if it's external, then data and value must both be null
      var.external ? (
        var.data == null && var.value == null
        ) : (
        # if it's not external, then either data or value may be set, but not both.
        (var.data != null || var.value != null) &&
        !(var.data != null && var.value != null)
      )
    )
    error_message = <<EOT
Data nor value can be set when external is true.
When external is false, either data or value must be set, but not both.
EOT
  }
}

variable "value" {
  description = "The string value of the configuration. Use either data or value, not both. This will take precedence over data if it is set."
  type        = string
  default     = null
  nullable    = true
}

variable "remap" {
  description = <<EOT
Renames the keys from a secret to specific names. If type env then use environment variable names, if type files then use file names. This is useful for remapping keys to more friendly names or to avoid conflicts with other configurations. Especially useful when the configuration is external and you don't have control over the keys. 

The keys in this map are the new names and the values are the original names. For example, if you have a secret with keys
`FOO` and `BAR`, but you want to use `BAZ` and `BUZ` in your application, you can set the remap to `{"BAZ" = "FOO", "BUZ" = "BAR"}`.
EOT
  type        = map(string)
  default     = null
  nullable    = true
}
