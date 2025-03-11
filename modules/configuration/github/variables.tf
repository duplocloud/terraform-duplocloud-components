variable "tenant" {
  description = "The tenant name."
  type        = string
}

variable "name" {
  description = "The simple name of the config. This name is used on volumes/volumeMounts as the name."
  type        = string
  default     = null
  nullable    = true
}

variable "repository" {
  description = "The repository name for the configuration."
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
  description = "The type of the config. This is used to determine how the config will be used."
  type        = string
  default     = "environment" # or files
  # make sure the value is one of the accepted values
  validation {
    condition = contains([
      "environment", "files"
    ], var.type)
    error_message = "The type must be one of the following: environment, files."
  }
}

variable "class" {
  description = "The class of the config."
  type        = string
  default     = "configmap"

  # make sure the value is one of the accepted values
  validation {
    condition = contains([
      "gh-variable", "gh-secret"
    ], var.class)
    error_message = "The class must be one of the following: configmap, secret."
  }
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

variable "data" {
  description = "The map of key/values for the configuration."
  type        = map(string)
  default     = null
  nullable    = true
  validation {
    condition = (
      (var.data != null || var.value != null) &&
      !(var.data != null && var.value != null)
    )
    error_message = "Either data or value must be set, but not both."
  }
}

variable "value" {
  description = "The string value of the configuration. Use either data or value, not both. This will take precedence over data if it is set."
  type        = string
  default     = null
  nullable    = true
}
