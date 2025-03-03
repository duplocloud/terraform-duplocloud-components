variable "name" {
  description = "The name of the tenant"
  type        = string
}

variable "infra_name" {
  description = "The name of the infrastructure to use"
  type        = string
}

variable "settings" {
  description = "The settings to apply to the tenant"
  type        = map(string)
  default     = {}
}

variable "configurations" {
  description = <<EOT
  A list of configurations for an application. These can be configmaps or secrets.

  With the `enable` field you can enable or disable the configuration from be configured with the app itself. When disabled, the resource is not deleted, it's just not mounted to the service anymore. Maybe you just are not ready yet or maybe you are trying to different ideas and don't want to delete the old one.

  The `managed` field determines if the configuration is managed by Terraform or not. If it is not managed, the configuration will not be updated by Terraform and it's expected you are using the duploctl CLI to update the configuration.

  The `data` key is a map of key value pairs that will be added to the configuration. 
  Use the `value` field if you want to set a single value for the configuration as a raw string. 
  
  If the `type` field is environment which is the default, then the data will be added as environment variables. If the `type` is file, then the data will be added as files.

  If the `type` is file, then you can optionally set where the mountPath is. If not set, it will be /mnt/<name>.

  If the class supports CSI, then the `csi` field can be set to true to use the CSI driver to mount the secret as a volume or envFrom. This makes a corresponding k8s secret alongside the csi compatibile secret.
  EOT
  type = list(object({
    enabled     = optional(bool, true)
    class       = optional(string, "configmap")
    external    = optional(bool, false)
    name        = optional(string, null)
    description = optional(string, null)
    type        = optional(string, "environment") # environment or file
    data        = optional(map(string), {})
    value       = optional(string, null)
    managed     = optional(bool, true)
    csi         = optional(bool, false)
    mountPath   = optional(string, null)
  }))
  default = []
}
