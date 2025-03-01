variable "tenant" {
  description = "The tenant name."
  type        = string
}

variable "class" {
  description = <<EOF
  The class of the load balancer to use.
  EOF
  type        = string
  default     = "service"
  validation {
    condition = contains([
      "elb",
      "alb",
      "health-only",
      "service",
      "node-port",
      "azure-shared-gateway",
      "nlb",
      "target-group",
      "ingress-alb",
      "standalone-alb"
    ], var.class)
    error_message = "The load balancer class must be one of 'elb', 'alb', 'health-only', 'service', 'node-port', 'azure-shared-gateway', 'nlb', 'target-group', 'ingress-alb'"
  }
}

variable "name" {
  description = "If the class is a singleton for a service than this name is a reference to the service this will be attached to."
  type        = string
}

variable "port" {
  description = "The port the application is listening on."
  type        = number
  default     = 80
}

variable "external_port" {
  description = "The external port to use for the load balancer."
  type        = number
  default     = null
  nullable    = true
}

variable "certificate" {
  description = <<EOF
  The `certificate` field will determine if the LB is HTTPS or not. If the field is not set, the LB will be HTTP.
  The value can be an ARN or a string that matches the certificate name in the AWS Certificate Manager. If the field is a name, the duplo provider will look up the ARN for you.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "protocol" {
  description = "The protocol to use for the load balancers backend."
  type        = string
  default     = "HTTP"

  validation {
    condition = contains([
      "HTTP",
      "HTTPS",
      "TCP",
      "UDP",
      "TLS",
      "TCP_UDP"
    ], upper(var.protocol))
    error_message = "The protocol must be one of 'HTTP', 'HTTPS', 'TCP', 'UDP', 'TLS', 'TCP_UDP'."
  }
}

variable "dns_prfx" {
  description = "The DNS prefix to use for the load balancer."
  type        = string
  default     = null
  nullable    = true
}

variable "health_check_url" {
  description = "The health check URL to use for the load balancer."
  type        = string
  default     = "/"
}

variable "internal" {
  description = "If the load balancer is internal or not."
  type        = bool
  default     = true
}

variable "listener" {
  description = <<EOF
  If the class is target-group, this is the listener ARN to attach the target group to.
  EOF
  type        = string
  default     = null
  nullable    = true
  validation {
    condition     = var.class != "target-group" || var.listener != null
    error_message = "Listener must be provided if class is 'target-group'."
  }
}

variable "path_pattern" {
  description = <<EOF
  If the class is target-group, this is the path pattern to use for the listener rule.
  EOF
  type        = string
  default     = "/*"
}

variable "priority" {
  description = <<EOF
  If the class is target-group, this is the priority to use for the listener rule.
  EOF
  type        = number
  default     = 1
}
