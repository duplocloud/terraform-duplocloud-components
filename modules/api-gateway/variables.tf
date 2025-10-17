variable "tenant_name" {
  type = string
}

variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "class" {
  description = "The class of api gateway"
  type        = string
  default     = "http"
  validation {
    condition     = contains(["http", "rest", "rest-private", "socket"], var.class)
    error_message = "Allowed values for input_parameter are http, rest, rest-private, socket"
  }
}

variable "body" {
  description = "The body of the api gateway as a string"
  type        = string
  nullable    = true
  default     = null
}

variable "openapi_file" {
  description = "Filepath to the open api file. Use interchangeably with providing the string in 'body'"
  type        = string
  nullable    = true
  default     = null
}

variable "openapi_variables" {
  description = "Extra parameters required for the open api template file that are not account id, duplo tenant, the domain, or the aws region"
  type        = map(any)
  default     = {}
}

# variable "enable_logging" {
#   description = "Enable logging for the gateway"
#   type        = bool
#   default     = true
# }

variable "enable_private_link" {
  description = "Enable private link for the gateway"
  type        = bool
  default     = false
}

variable "vpc_link_targets" {
  description = "The list of vpc link targets when type is not http, ie rest, private-rest, or socket"
  type        = list(string)
  default     = []
}

variable "mappings" {
  description = <<EOT
Defines a list of mapping objects for API Gateway configuration.

Fields:
  - domain (string, required): The domain name for the mapping. If a simple DNS-style name (without dots) is provided, the domain will be looked up automatically.
  - external (bool, optional, default false): Indicates if the domain is pre-existing. If true, no new domain will be created for this mapping.
  - cert (string, optional, default null): Certificate name or ARN to use when creating a new domain. Only applicable when external is false; if a name is provided, it will be looked up.
  - path (string, optional, default null): Specifies the path for REST gateways or the mapping key for HTTP gateways.
EOT
  type = list(object({
    external = optional(bool, false)
    cert     = optional(string, null)
    domain   = string
    path     = optional(string, null)
  }))
  default = []
}
