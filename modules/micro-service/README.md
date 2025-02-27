# Simple Micro Service  

Creates a Duplo service with a single service with the option to expose an lb. 

## Usage

```hcl
module "micro-service" {
  source = "duplocloud/components/duplocloud//modules/micro-service"
  version = "0.0.23"
  name = "micro-service"
  image = "nginx:latest"
  port = 80
  lb = {
    enabled = true
    class = "alb"
    certificate = "my-cert"
  }
  env = {
    SOMETHING = "This and $(MESSAGE)"
  }
  configurations = [{
    data = {
      MESSAGE = "Hello World"
    }
  }]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.40)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (0.11.0)

- <a name="provider_random"></a> [random](#provider\_random) (3.6.3)

## Modules

The following Modules are called:

### <a name="module_configurations"></a> [configurations](#module\_configurations)

Source: ../configuration

Version:

## Resources

The following resources are used by this module:

- [duplocloud_aws_lb_listener_rule.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_lb_listener_rule) (resource)
- [duplocloud_duplo_service.managed](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service) (resource)
- [duplocloud_duplo_service.unmanaged](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service) (resource)
- [duplocloud_duplo_service_lbconfigs.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service_lbconfigs) (resource)
- [duplocloud_duplo_service_params.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service_params) (resource)
- [duplocloud_k8s_job.before_update](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8s_job) (resource)
- [random_string.release_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [duplocloud_plan_certificate.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/plan_certificate) (data source)
- [duplocloud_tenant.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the service and the prefix for the resources.

Type: `string`

### <a name="input_tenant"></a> [tenant](#input\_tenant)

Description: The name of the tenant.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_annotations"></a> [annotations](#input\_annotations)

Description: Annotations to add to the service.

Type: `map(string)`

Default: `{}`

### <a name="input_args"></a> [args](#input\_args)

Description: The arguments to pass to the command. This is using kubernetes command syntax.

Type: `list(string)`

Default: `[]`

### <a name="input_command"></a> [command](#input\_command)

Description: The command to run in the container. This is using kubernetes command syntax.

Type: `list(string)`

Default: `[]`

### <a name="input_configurations"></a> [configurations](#input\_configurations)

Description:   A list of configurations for an application. These can be configmaps or secrets.

  With the `enable` field you can enable or disable the configuration from be configured with the app itself. When disabled, the resource is not deleted, it's just not mounted to the service anymore. Maybe you just are not ready yet or maybe you are trying to different ideas and don't want to delete the old one.

  The `managed` field determines if the configuration is managed by Terraform or not. If it is not managed, the configuration will not be updated by Terraform and it's expected you are using the duploctl CLI to update the configuration.

  The `data` key is a map of key value pairs that will be added to the configuration.   
  Use the `value` field if you want to set a single value for the configuration as a raw string.   

  If the `type` field is environment which is the default, then the data will be added as environment variables. If the `type` is file, then the data will be added as files.

  If the `type` is file, then you can optionally set where the mountPath is. If not set, it will be /mnt/<name>.

  If the class supports CSI, then the `csi` field can be set to true to use the CSI driver to mount the secret as a volume or envFrom. This makes a corresponding k8s secret alongside the csi compatibile secret.

Type:

```hcl
list(object({
    enabled     = optional(bool, true)
    external    = optional(bool, false)
    name        = optional(string, null)
    description = optional(string, null)
    type        = optional(string, "environment") # environment or file
    data        = optional(map(string), {})
    value       = optional(string, null)
    managed     = optional(bool, true)
    class       = optional(string, "configmap")
    csi         = optional(bool, false)
    mountPath   = optional(string, null)
  }))
```

Default: `[]`

### <a name="input_env"></a> [env](#input\_env)

Description: The environment variables to set on the container of the service.

Type: `map(string)`

Default: `{}`

### <a name="input_health_check"></a> [health\_check](#input\_health\_check)

Description:   
  The health check configuration for the service. This includes the path, failureThreshold, initialDelaySeconds, periodSeconds, successThreshold, and timeoutSeconds.

  The `enabled` field will determine if the health check is enabled or not. If the field is not set, the health check will be enabled.

  The `path` field will determine the path that the health check will use. If the field is not set, the path will be "/".

Type:

```hcl
object({
    enabled             = optional(bool, true)
    path                = optional(string, "/")
    failureThreshold    = optional(number, 3)
    initialDelaySeconds = optional(number, 15)
    periodSeconds       = optional(number, 20)
    successThreshold    = optional(number, 1)
    timeoutSeconds      = optional(number, 1)
  })
```

Default: `{}`

### <a name="input_image"></a> [image](#input\_image)

Description:   The configuration for which image and how to handle it.  
  This includes the pull policy and the URI of the image.

  If `uri` is set then this is used. Otherwise set the `repo`, `registry`, and `tag` to build the URI. If none of these values are set, then it's assumed the app name is the repo, the registry is docker.io, and the tag is latest, ie `docker.io/myapp:latest`.

  The `pullPolicy` field determines how the image is pulled. It can be one of the following: `Always`, `IfNotPresent`, or `Never`.

  The `managed` field determines if the images is updated by Terraform or not. If it is not managed, the image will not be updated by Terraform and it's expected you are using the duploctl CLI to update the image.

Type:

```hcl
object({
    uri        = optional(string, null)
    tag        = optional(string, "latest")
    repo       = optional(string, null)
    registry   = optional(string, "docker.io")
    pullPolicy = optional(string, "IfNotPresent")
    managed    = optional(bool, true)
  })
```

Default: `{}`

### <a name="input_jobs"></a> [jobs](#input\_jobs)

Description:   The jobs for the service.

  The `enabled` field will determine if the job is enabled or not. If the field is not set, the job will be enabled.

  The `name` field will determine the suffix to add to the job name and act as the id. If the field is not set, the name will be the event name.

  The `command` field will determine the command to run. If the field is not set, the command will use whatever is configured in the containers image or the var.command if it has been set.

  The `args` field will determine the arguments to pass to the command. If the field is not set, the args will be an empty list.

  The `wait` field will determine if the job should wait for completion. If the field is not set, the job will wait for completion.

  The `event` field will determine the event to trigger the job. If the field is not set, the event will be "before-update". This can be one of the following: before-update, after-update, before-delete, after-delete.

Type:

```hcl
list(object({
    enabled  = optional(bool, true)
    name     = optional(string, null)
    command  = optional(list(string), null)
    args     = optional(list(string), [])
    wait     = optional(bool, true)
    event    = optional(string, "before-update")
    schedule = optional(string, "0 1 * * *")
  }))
```

Default: `[]`

### <a name="input_labels"></a> [labels](#input\_labels)

Description: Labels to add to the service.

Type: `map(string)`

Default: `{}`

### <a name="input_lb"></a> [lb](#input\_lb)

Description: Expose the service via a load balancer.

Use the `enabled` field to enable or disable the load balancer.

The type of load balancer can be one of the following:
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

If the type is `target-group`, the `listener` field must be set to the ARN of the listener that the target group will be attached to.

See more docs here: https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service_lbconfigs

Type:

```hcl
object({
    enabled      = optional(bool, false)
    type         = optional(string, "service")
    priority     = optional(number, 0)
    path_pattern = optional(string, "/*")
    port         = optional(number, null)
    protocol     = optional(string, "http")
    certificate  = optional(string, "")
    listener     = optional(string, null)
    dns_prfx     = optional(string, null)
  })
```

Default: `{}`

### <a name="input_nodes"></a> [nodes](#input\_nodes)

Description:   The configuration for which nodes to run the service on.

Type:

```hcl
object({
    allocation_tags = optional(string, null)
    shared          = optional(bool, false)
    selector        = optional(map(string), null)
  })
```

Default: `{}`

### <a name="input_pod_annotations"></a> [pod\_annotations](#input\_pod\_annotations)

Description: Annotations to add to the pod.

Type: `map(string)`

Default: `{}`

### <a name="input_pod_labels"></a> [pod\_labels](#input\_pod\_labels)

Description: Labels to add to the pod.

Type: `map(string)`

Default: `{}`

### <a name="input_port"></a> [port](#input\_port)

Description: The port number the app listens on. This is used for healthchecks on the lb and pod.

Type: `number`

Default: `80`

### <a name="input_release_id"></a> [release\_id](#input\_release\_id)

Description:   The `release_id` field is the id of the current build. If the field is not set, a random id will be generated. When running in a CI/CD pipeline, it's recommended to set this field to the Job ID in the pipeline so the k8s job and the job id from the pipeline match up.

Type: `string`

Default: `null`

### <a name="input_resources"></a> [resources](#input\_resources)

Description: The resource requests and limits for the service.

Type:

```hcl
object({
    requests = optional(map(string))
    limits   = optional(map(string))
  })
```

Default: `{}`

### <a name="input_restart_policy"></a> [restart\_policy](#input\_restart\_policy)

Description: n/a

Type: `string`

Default: `"Always"`

### <a name="input_scale"></a> [scale](#input\_scale)

Description:   The configuration for how to scale the service.  
  This includes the replicas, min, and max.

  The `auto` field determines if the service should be autoscaled. If it is not autoscaled, the replicas field will be used.

  The metrics field is a list of metrics to use for autoscaling. This includes the type and target.

Type:

```hcl
object({
    auto     = optional(bool, false)
    replicas = optional(number, 1)
    min      = optional(number, 1)
    max      = optional(number, 3)
    metrics = optional(list(object({
      type   = string
      target = number
    })), [])
  })
```

Default: `{}`

### <a name="input_secrets"></a> [secrets](#input\_secrets)

Description: The list of external secret names to be mounted as envFrom.

Type: `list(string)`

Default: `[]`

### <a name="input_security_context"></a> [security\_context](#input\_security\_context)

Description: The security context for the service.

Type:

```hcl
object({
    run_as_user  = optional(number, null)
    run_as_group = optional(number, null)
    fs_group     = optional(number, null)
  })
```

Default: `null`

### <a name="input_volume_mounts"></a> [volume\_mounts](#input\_volume\_mounts)

Description:   The volume mounts for the service. This includes the name, mountPath, and subPath.

  The `name` field is the name of the volume mount.

  The `mountPath` field is the path to mount the volume to.

  The `subPath` field is the path to the file to mount.

Type:

```hcl
list(object({
    name      = string
    mountPath = string
    readOnly  = optional(bool, false)
    subPath   = optional(string, null)
  }))
```

Default: `[]`

### <a name="input_volumes_json"></a> [volumes\_json](#input\_volumes\_json)

Description:   The volumes for the service in JSON format. This is useful for when you want to use a JSON string to define the volumes.

Type: `string`

Default: `"[]"`

## Outputs

The following outputs are exported:

### <a name="output_configurations"></a> [configurations](#output\_configurations)

Description: The configurations object.

### <a name="output_release_id"></a> [release\_id](#output\_release\_id)

Description: The random release id for this deployment.

### <a name="output_volumes"></a> [volumes](#output\_volumes)

Description: The list of volumes mounted to the service.
<!-- END_TF_DOCS -->
