variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
}

variable "name" {
  description = "Name of the website"
  type        = string
}

variable "sites" {
  description = <<EOT
List of sites to create. The name will default to the sites name. 
Ideally you leave the first site without a name and let it use the name variable. 
EOT
  type = set(object({
    name   = optional(string)
    bucket = string
    path   = string
  }))
}

variable "dns_prefix" {
  description = <<EOT
The prefix to use for the website in front of the domain defined by the zone. Will default to <tenant-name> if this is left as null.
EOT
  type        = string
  default     = null
  nullable    = true
}

variable "dns_zone_name" {
  description = "Name of the DNS zone"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "default_url_redirect" {
  description = "redirect behavior for any unmatched requests"
  type = object({
    host_redirect          = string
    https_redirect         = bool
    path_redirect          = string
    redirect_response_code = string
    strip_query            = bool
  })
  default = null
}
