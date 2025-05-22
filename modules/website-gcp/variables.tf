variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
}

variable "sites" {
  description = "List of sites to create"
  type = set(object({
    name   = string
    bucket = string
    path   = string
  }))
}

variable "domain" {
  description = "Domain name for the website"
  type        = string
}

variable "dns_name" {
  description = "DNS name for the website"
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the DNS zone"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "url_map_name" {
  description = "Name of the URL map"
  type        = string
  default     = "dev01-static-sites"
}
variable "proxy_name" {
  description = "Name of the target proxy"
  type        = string
  default     = "dev01-website"
}
variable "cert_name" {
  description = "Name of the SSL certificate"
  type        = string
  default     = "dev01-website-cert"
}
variable "global_address_name_suffix" {
  default = "-websites-ip"
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
