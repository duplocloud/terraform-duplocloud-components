variable "repos" {
  description = <<EOT
A list of Github repository names. 
Each one will get a new environment matching the name of the tenant.
EOT
  type        = list(string)
  default     = []
}
