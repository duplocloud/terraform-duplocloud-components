variable "tenant" {
  type        = string
  description = "The name of the tenant."
}

variable "name" {
  description = "The name of the service and the prefix for the resources."
  type        = string
}

variable "release_id" {
  description = <<EOT
  The `release_id` field is the id of the current build. If the field is not set, a random id will be generated. When running in a CI/CD pipeline, it's recommended to set this field to the Job ID in the pipeline so the k8s job and the job id from the pipeline match up. 
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "command" {
  description = "The command to run in the container. This is using kubernetes command syntax."
  type        = list(string)
  default     = []
}

variable "args" {
  description = "The arguments to pass to the command. This is using kubernetes command syntax."
  type        = list(string)
  default     = []
}

variable "port" {
  description = "The port number the app listens on. This is used for healthchecks on the lb and pod."
  type        = number
  default     = 80
}

variable "env" {
  description = "The environment variables to set on the container of the service."
  type        = map(string)
  default     = {}
}

variable "image" {
  description = <<EOT
  The configuration for which image and how to handle it.
  This includes the pull policy and the URI of the image. 

  If `uri` is set then this is used. Otherwise set the `repo`, `registry`, and `tag` to build the URI. If none of these values are set, then it's assumed the app name is the repo, the registry is docker.io, and the tag is latest, ie `docker.io/myapp:latest`.

  The `pullPolicy` field determines how the image is pulled. It can be one of the following: `Always`, `IfNotPresent`, or `Never`.

  The `managed` field determines if the images is updated by Terraform or not. If it is not managed, the image will not be updated by Terraform and it's expected you are using the duploctl CLI to update the image.
  EOT
  type = object({
    uri        = optional(string, null)
    tag        = optional(string, "latest")
    repo       = optional(string, null)
    registry   = optional(string, "docker.io")
    pullPolicy = optional(string, "IfNotPresent")
    managed    = optional(bool, true)
  })
  default = {}
  validation {
    condition     = can(regex("^(Always|IfNotPresent|Never)$", var.image.pullPolicy))
    error_message = "The pull policy must be one of 'Always', 'IfNotPresent', or 'Never'"
  }
}

variable "scale" {
  description = <<EOT
  The configuration for how to scale the service.
  This includes the replicas, min, max, and the metrics for determining how to auto scale.

  The metrics field is a list of metrics to use for autoscaling. Auto scaling is considered `enabled` when there are metrics, if there are none then the service will only use the replica count. See [Kubernetes Horizontal Pod Autoscale Walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) for more information.
  EOT
  type = object({
    replicas = optional(number, null)
    min      = optional(number, null)
    max      = optional(number, null)
    metrics = optional(list(object({
      type = string
      resource = optional(object({
        name = string
        target = object({
          type               = string
          averageUtilization = optional(number)
          averageValue       = optional(string)
          value              = optional(string)
        })
      }))
      pods = optional(object({
        metric = object({
          name     = string
          selector = optional(map(string))
        })
        target = object({
          type               = string
          averageUtilization = optional(number)
          averageValue       = optional(string)
          value              = optional(string)
        })
      }))
      object = optional(object({
        metric = object({
          name     = string
          selector = optional(map(string))
        })
        describedObject = object({
          apiVersion = string
          kind       = string
          name       = string
        })
        target = object({
          type               = string
          averageUtilization = optional(number)
          averageValue       = optional(string)
          value              = optional(string)
        })
      }))
    })))
  })
  default = {}
}

variable "restart_policy" {
  type    = string
  default = "Always"
  validation {
    condition     = can(regex("^(Always|OnFailure|Never)$", var.restart_policy))
    error_message = "The restart policy must be one of 'Always', 'OnFailure', or 'Never'"
  }
}

variable "annotations" {
  description = "Annotations to add to the service."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to add to the service."
  type        = map(string)
  default     = {}
}

variable "pod_annotations" {
  description = "Annotations to add to the pod."
  type        = map(string)
  default     = {}
}

variable "pod_labels" {
  description = "Labels to add to the pod."
  type        = map(string)
  default     = {}
}

variable "resources" {
  description = "The resource requests and limits for the service."
  type = object({
    requests = optional(map(string))
    limits   = optional(map(string))
  })
  default = {}
}

variable "security_context" {
  description = "The security context for the service."
  type = object({
    run_as_user  = optional(number, null)
    run_as_group = optional(number, null)
    fs_group     = optional(number, null)
  })
  default  = null
  nullable = true
}

variable "service_account_name" {
  description = "The service account name for the service"
  type        = string
  default     = ""
}

variable "nodes" {
  description = <<EOT
  The configuration for which nodes to run the service on.

  The `shared` field will determine if the service can run on shared nodes or not. If the field is not set, the service will only run on nodes within its own tenant. 

  The `allocation_tags` field is a list of tags to use for allocating the nodes. If the field is not set, the service will run on any node within a tenant. If the `shared` field is set, then the allocation_tags may be ones from another tenant sharing it's nodes. 

  The `selector` field is a map of labels to use for selecting the nodes. If the field is not set, the service will run on any node within a tenant. If the `shared` field is set, then the selector may use labels on nodes from tenants sharing their nodes.

  The `unique` field will determine if the service should run on a unique node or not. This will treat a normal service kind of like a daemonset. In the background, the pod is asking to be on nodes which don't have one of itself already on it. 

  The `spread_across_zones` field will determine if the service should be spread across zones or not. The scheduler will pick the least used node it can which might be another node in a zone that already has one of itself. This ensures the scheduler will also consider the least used zone it can. 
  EOT
  type = object({
    shared              = optional(bool, false)
    allocation_tags     = optional(string, null)
    selector            = optional(map(string), null)
    unique              = optional(bool, false)
    spread_across_zones = optional(bool, false)
  })
  default = {}
}

variable "lb" {
  description = <<EOT
Expose the service via a load balancer. 

Use the `enabled` field to enable or disable the load balancer.

The `class` of load balancer can be one of the following: 
- elb
- alb
- health-only
- service
- node-port
- azure-shared-gateway
- nlb
- target-group

The `certificate` field will determine if the LB is HTTPS or not. If the field is not set, the LB will be HTTP.
The value can be an ARN or a string that matches the certificate name in the AWS Certificate Manager. If the field is a name, the duplo provider will look up the ARN for you.

The `external_port` field will determine the port that the load balancer will listen on. If the field is not set, the port will be 80 for HTTP and 443 for HTTPS depending on weether or not the `certificate` field is set.

If the class is `target-group`, the `listener` field must be set to the ARN of the listener that the target group will be attached to.

The `dns_prfx` field will determine the subdomain for the base host tenant. If the field is not set, the prefix will be the service name and tenant name.

The `release_header` is a boolean option which, when enabled, will add a header rule to the load balancer requiring the release ID on `X-Access-Control`. The release ID is an output, this means you can use it on a CDN to inject the corresponding header so the cdn is the only thing talking to the lb. 

See more docs here: https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service_lbconfigs
EOT
  type = object({
    enabled        = optional(bool, false)
    class          = optional(string, "service")
    priority       = optional(number, 0)
    path_pattern   = optional(string, "/*")
    port           = optional(number, null)
    protocol       = optional(string, null)
    certificate    = optional(string, null)
    listener       = optional(string, null)
    dns_prfx       = optional(string, null)
    internal       = optional(bool, false)
    release_header = optional(bool, false)
    annotations    = optional(map(string), {})
  })
  default = {}
}

variable "health_check" {
  description = <<EOT

  The health check configuration for the service. This includes the path, failureThreshold, initialDelaySeconds, periodSeconds, successThreshold, and timeoutSeconds.

  The `enabled` field will determine if the health check is enabled or not. If the field is not set, the health check will be enabled.

  The `path` field will determine the path that the health check will use. If the field is not set, the path will be "/".

  EOT
  type = object({
    enabled             = optional(bool, true)
    path                = optional(string, "/")
    failureThreshold    = optional(number, 3)
    initialDelaySeconds = optional(number, 15)
    periodSeconds       = optional(number, 20)
    successThreshold    = optional(number, 1)
    timeoutSeconds      = optional(number, 1)
  })
  default = {}
}

variable "secrets" {
  description = "The list of external secret names to be mounted as envFrom."
  type        = list(string)
  default     = []
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

variable "volume_mounts" {
  description = <<EOT
  The volume mounts for the service. This includes the name, mountPath, and subPath.

  The `name` field is the name of the volume mount.

  The `mountPath` field is the path to mount the volume to.

  The `subPath` field is the path to the file to mount.
  EOT
  type = list(object({
    name      = string
    mountPath = string
    readOnly  = optional(bool, false)
    subPath   = optional(string, null)
  }))
  default = []
}

# variable "volumes" {
#   description = <<EOT
#   The volumes for the service. This includes the name, type, and config.

#   The `name` field is the name of the volume.

#   The `type` field is the type of the volume. This can be one of the following: configMap, secret, or emptyDir.

#   The `config` field is the configuration for the volume. This can be one of the following: name, items, or sizeLimit.
#   EOT
#   type = list(object({
#     name   = string
#     type   = string
#     config = map(string)
#   }))
#   default = []
# }

variable "volumes_json" {
  description = <<EOT
  The volumes for the service in JSON format. This is useful for when you want to use a JSON string to define the volumes.
  EOT
  type        = string
  default     = "[]"
}

variable "jobs" {
  description = <<EOT
  The jobs for the service. 

  The `enabled` field will determine if the job is enabled or not. If the field is not set, the job will be enabled.

  The `name` field will determine the suffix to add to the job name and act as the id. If the field is not set, the name will be the event name.

  The `command` field will determine the command to run. If the field is not set, the command will use whatever is configured in the containers image or the var.command if it has been set.

  The `args` field will determine the arguments to pass to the command. If the field is not set, the args will be an empty list.

  The `wait` field will determine if the job should wait for completion. If the field is not set, the job will wait for completion.

  The `event` field will determine the event to trigger the job. If the field is not set, the event will be "before-update". This can be one of the following: before-update, after-update, before-delete, after-delete.

  The `timeout` field will determine the timeout for the job. If the field is not set, the timeout will be 60 seconds.

  The `labels` field will determine the labels to add to the job. If the field is not set, the labels will be an empty map. These are applied to the job and on the pod merged with pod labels.

  The `annotations` field will determine the annotations to add to the job. If the field is not set, the annotations will be an empty map. These are applied to the job and on the pod merged with pod annotations.

  The `env` field will determine the environment variables to add to the job. If the field is not set, the env will be an empty map. These are applied to the job and on the pod merged with pod env.
  EOT
  type = list(object({
    enabled     = optional(bool, true)
    name        = optional(string, null)
    command     = optional(list(string), null)
    args        = optional(list(string), [])
    wait        = optional(bool, true)
    event       = optional(string, "before-update")
    schedule    = optional(string, "0 1 * * *")
    timeout     = optional(string, "1m")
    labels      = optional(map(string), {})
    annotations = optional(map(string), {})
    env         = optional(map(string), {})
  }))
  default = []

  validation {
    # redo the condition uses contains instead of regex
    condition = alltrue([for job in var.jobs : contains([
      "before-update", "after-update",
      "before-delete", "after-delete",
      "cron"
    ], job.event)])
    error_message = "The event must be one of 'before-update', 'after-update', 'before-delete', or 'after-delete'"
  }
}

variable "cloud" {
  description = "Set to GCP to enable gcp capability"
  type        = string
  default     = "AWS"
}

variable "host_network" {
  description = "Set to true to enable host networking mode"
  type        = bool
  default     = null
}

variable "termination_grace_period" {
  description = "The amount of time to wait, in seconds, for pod activity to terminate gracefully after shutdown signal"
  type        = number
  default     = null
}

variable "deployment_strategy" {
  description = <<EOT
  The deployment strategy to use.  If "RollingUpdate", optionally provide MaxSurge and MaxUnavailable.
  EOT
  type              = object({
    type            = optional(string, "RollingUpdate" )
    maxSurge        = optional(string, "25%")
    maxUnavailable  = optional(string, "25%")
  })
  default     = {}
  validation {
    condition = (
      var.deployment_strategy == {} ||
      contains(["RollingUpdate", "Recreate"], var.deployment_strategy.type)
    )
    error_message = "When deployment_strategy is set, you must set type to either 'RollingUpdate' or 'Recreate'"
  }
}