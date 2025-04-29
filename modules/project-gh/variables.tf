variable "name" {
  description = "Name of the project."
}

variable "owner" {
  description = "Name of the organization, user, or group."
  type        = string
  default     = null
  nullable    = true
}

variable "description" {
  description = "Description of the project."
  type        = string
  default     = null
  nullable    = true
}

variable "mode" {
  description = <<EOT
The way in which terraform will manage this resource. Each mode will determine if and how terraform is eitehr managing or just reading from.
EOT
  type        = string
  default     = "resource"
  validation {
    condition = contains([
      "resource",
      "data"
    ], var.mode)
    error_message = "The type must be one of the following: resource, data, import."
  }
}

variable "class" {
  description = "The class of the project."
  type        = string
  default     = "generic"
  # make sure the value is one of the accepted values
  validation {
    condition = contains([
      "service",
      "website",
      "library",
      "package",
      "cli",
      "monorepo",
      "lambda",
      "serverless",
      "infrastructure",
      "cicd",
      "generic"
    ], var.class)
    error_message = <<EOT
The class must be one of the following: 
- service
- website
- library
- package
- monorepo
- lambda
- serverless
- infrastructure
- cicd
- generic
EOT
  }
}

variable "cloud" {
  description = "Set to GCP to enable gcp capability"
  type        = string
  default     = "AWS"
  validation {
    condition = contains([
      "AWS",
      "GCP",
      "AZURE"
    ], var.cloud)
    error_message = "The cloud must be one of the following: AWS, GCP, AZURE."
  }
}

variable "visibility" {
  description = "Visibility of the project."
  type        = string
  default     = "private"
  # make sure the value is one of the accepted values
  validation {
    condition = contains([
      "public",
      "private"
    ], var.visibility)
    error_message = "The visibility must be either public or private."
  }
}

variable "workflows" {
  description = <<EOT

EOT
  type = map(object({
    enabled    = optional(bool, true)
    conditions = optional(map(list(string)), {})
    content    = optional(string, null)
  }))
  default = {}
}
