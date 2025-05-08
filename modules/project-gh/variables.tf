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
Each workflows describes a Gtihub Action Workflow file and under what conditons it should be added to the repo. This provides a dynamic way to manage the files themselves especially when a lot of repos are using the same exact or slightly different workflows.

The `content` is the actual content of the workflow file. This can be a string or a template file. If it's a string then it will be used as is. If it's a template file then it will be rendered with the context provided in the `context` key. The properties themselves are available in the template as the `props` variable, eg `props.my_prop[0] == "true"` because all the props are arrrays. 
 
The `conditions` are the allowed values for certain properties that determine when the workflow is present in the repo. So if a repo has the has_image set to true then the image workflow is added to the repo. 

The `context` are extra values you want included in the variables for the template provided in the content key. 
EOT
  type = map(object({
    enabled    = optional(bool, true)
    conditions = optional(map(list(string)), null)
    content    = optional(string, null)
    context    = optional(map(any), {})
  }))
  default = {}
}
