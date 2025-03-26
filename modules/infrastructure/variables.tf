variable "name" {
  description = "The name of the infrastructure. If null the terraform.workspace will be used."
  type        = string
  nullable    = true
  default     = null
}

variable "cloud" {
  description = "The cloud this is deployed on."
  type        = string
  default     = "aws"

  validation {
    condition     = contains(["aws", "oracle", "azure", "google"], var.cloud)
    error_message = "The cloud must be one of the following: aws, oracle, azure, google."
  }
}

variable "class" {
  description = <<EOT
The class of the infrastructure determines what kind of cloud this will be. 
By default the `duplocloud` option will use only VMs with Docker native. 
Using `k8s` will use a Kubernetes cluster. This is EKS on AWS, GKE on Google, AKS on Azure and OKE on Oracle.
The `ecs` option is for AWS only and makes an ECS cluster based infrastructure. 
EOT
  type        = string
  default     = "duplocloud"

  validation {
    condition     = contains(["duplocloud", "k8s", "ecs"], var.class)
    error_message = "The class must be one of the following: duplocloud, k8s, ecs."
  }
}

variable "region" {
  description = "The region to place the infrastructure in."
  type        = string
  default     = "us-west-2"
}

variable "address_prefix" {
  description = "The CIDR block for the infrastructure."
  type        = string
  default     = null
  nullable    = true
}

variable "azcount" {
  description = "How many Availability Zones to use."
  type        = number
  default     = 2
}

variable "subnet_cidr" {
  description = "The base of each of the subnets."
  type        = number
  default     = 22
}

variable "metadata" {
  description = "A map of metadata to be used in the infrastructure."
  type        = map(string)
  default     = null
  nullable    = true
}

variable "settings" {
  description = "A map of the settings for the infrastructure."
  type        = map(string)
  default     = null
  nullable    = true
}

variable "subnets" {
  description = "A list of subnets to be used in the infrastructure."
  type = map(object({
    cidr_block = string
    zone       = optional(string, "A")
    type       = optional(string, "private")
    tags       = optional(map(string), null)
  }))
  default = {}
}

variable "configs" {
  description = <<EOT
A list of Duplocloud Plan configurations associated with this infra.
https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/plan_configs
EOT
  type = list(object({
    key   = string
    type  = string
    value = string
  }))
  default  = null
  nullable = true
}

variable "dns" {
  description = "Configuration for the DNS to use."
  type = object({
    domain_id       = string
    internal_suffix = string
    external_suffix = string
    ignore_global   = optional(bool, false)
  })
  default  = null
  nullable = true
}

variable "certificates" {
  description = "A map of names and their IDs to import into the plan. The first one is the default."
  type        = map(string)
  default     = null
  nullable    = true
}
