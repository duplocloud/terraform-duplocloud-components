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

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.0)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.11.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (0.12.18)

- <a name="provider_random"></a> [random](#provider\_random) (3.9.1)

## Modules

The following Modules are called:

### <a name="module_configurations"></a> [configurations](#module\_configurations)

Source: ../configuration

Version:

### <a name="module_loadbalancer"></a> [loadbalancer](#module\_loadbalancer)

Source: ../loadbalancer

Version:

## Resources

The following resources are used by this module:

- [duplocloud_duplo_service.managed](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service) (resource)
- [duplocloud_duplo_service.unmanaged](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/duplo_service) (resource)
- [duplocloud_k8s_job.before_update](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8s_job) (resource)
- [random_string.release_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
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

### <a name="input_cloud"></a> [cloud](#input\_cloud)

Description: Set to GCP to enable gcp capability

Type: `string`

Default: `"AWS"`

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
```

Default: `[]`

### <a name="input_container_lifecycle"></a> [container\_lifecycle](#input\_container\_lifecycle)

Description: The Kubernetes container lifecycle hooks. These are used to run commands at different stages of the container lifecycle.

Type:

```hcl
object({
    preStop = optional(object({
      exec = optional(object({
        command = list(string)
      }), null)
      httpGet = optional(object({
        path   = string
        port   = number
        scheme = optional(string, "HTTP")
      }), null)
      tcpSocket = optional(object({
        port = number
      }), null)
    }), null)
    postStart = optional(object({
      exec = optional(object({
        command = list(string)
      }), null)
      httpGet = optional(object({
        path   = string
        port   = number
        scheme = optional(string, "HTTP")
      }), null)
      tcpSocket = optional(object({
        port = number
      }), null)
    }), null)
  })
```

Default: `null`

### <a name="input_container_security_context"></a> [container\_security\_context](#input\_container\_security\_context)

Description:   The main container's security context (Kubernetes container `securityContext`) for the service.

  The `allow_privilege_escalation`, `read_only_root_filesystem`, `run_as_non_root`, `run_as_user`,
  `run_as_group`, and `privileged` fields map directly to their Kubernetes camelCase equivalents.

  The `capabilities` field is an object with `add` and `drop` lists of capability names, mapping  
  to Kubernetes `capabilities.add` and `capabilities.drop`.

Type:

```hcl
object({
    allow_privilege_escalation = optional(bool, null)
    read_only_root_filesystem  = optional(bool, null)
    run_as_non_root            = optional(bool, null)
    run_as_user                = optional(number, null)
    run_as_group               = optional(number, null)
    privileged                 = optional(bool, null)
    capabilities = optional(object({
      add  = optional(list(string), null)
      drop = optional(list(string), null)
    }), null)
  })
```

Default: `null`

### <a name="input_debug"></a> [debug](#input\_debug)

Description: Set to true to enable debug mode. This will override the command and args and prevent the container from crashing. All the health probes will be disabled.

Type: `bool`

Default: `false`

### <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy)

Description:   The deployment strategy to use.  If "RollingUpdate", optionally provide MaxSurge and MaxUnavailable.

Type:

```hcl
object({
    type           = optional(string, "RollingUpdate")
    maxSurge       = optional(string, "25%")
    maxUnavailable = optional(string, "25%")
  })
```

Default: `null`

### <a name="input_env"></a> [env](#input\_env)

Description: The environment variables to set on the container of the service.

Type: `map(string)`

Default: `{}`

### <a name="input_health_check"></a> [health\_check](#input\_health\_check)

Description:   
  The health check configuration for the service. This includes the path, failureThreshold, initialDelaySeconds, periodSeconds, successThreshold, and timeoutSeconds.

  The `enabled` field will determine if the health check is enabled or not. If the field is not set, the health check will be enabled.

  The `path` field will determine the path that the health check will use. If the field is not set, the path will be "/".

  The `set_ingress_health_check` needs to be set to true if you have a single ingress fronting multiple clusterip services with healthchecks other than "/"

  The `type` field determines the probe mechanism: "http" (default) uses an `httpGet` probe against `path`/`port`;
  "tcp" uses a `tcpSocket` probe against `port` only (`path` is ignored); "grpc" uses a `grpc` probe against `port`  
  and, optionally, `grpc_service` (the gRPC health-checking protocol's service name; if not set, the default service  
  is checked). Each of `liveness`, `readiness`, and `startup` may override `type`, `port`, and `grpc_service`  
  individually; if not set, they inherit the top-level values.

Type:

```hcl
object({
    enabled                  = optional(bool, true)
    path                     = optional(string, "/")
    set_ingress_health_check = optional(bool, false)
    port                     = optional(number, null)   # If not set, the port will be the service port
    type                     = optional(string, "http") # "http", "tcp", or "grpc"
    grpc_service             = optional(string, null)   # only used when type is "grpc"
    failureThreshold         = optional(number, 3)
    initialDelaySeconds      = optional(number, 15)
    periodSeconds            = optional(number, 20)
    successThreshold         = optional(number, 1)
    timeoutSeconds           = optional(number, 1)
    liveness = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, null)
      port                = optional(number, null) # If not set, the port will be the service port
      type                = optional(string, null) # "http", "tcp", or "grpc"; defaults to the top-level type
      grpc_service        = optional(string, null) # only used when type is "grpc"; defaults to the top-level value
      failureThreshold    = optional(number, null)
      initialDelaySeconds = optional(number, null)
      periodSeconds       = optional(number, null)
      successThreshold    = optional(number, null)
      timeoutSeconds      = optional(number, null)
    }), {})
    readiness = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, null)
      port                = optional(number, null) # If not set, the port will be the service port
      type                = optional(string, null) # "http", "tcp", or "grpc"; defaults to the top-level type
      grpc_service        = optional(string, null) # only used when type is "grpc"; defaults to the top-level value
      failureThreshold    = optional(number, null)
      initialDelaySeconds = optional(number, null)
      periodSeconds       = optional(number, null)
      successThreshold    = optional(number, null)
      timeoutSeconds      = optional(number, null)
    }), {})
    startup = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, null)
      port                = optional(number, null) # If not set, the port will be the service port
      type                = optional(string, null) # "http", "tcp", or "grpc"; defaults to the top-level type
      grpc_service        = optional(string, null) # only used when type is "grpc"; defaults to the top-level value
      failureThreshold    = optional(number, null)
      initialDelaySeconds = optional(number, null)
      periodSeconds       = optional(number, null)
      successThreshold    = optional(number, null)
      timeoutSeconds      = optional(number, null)
    }), {})
  })
```

Default: `{}`

### <a name="input_host_network"></a> [host\_network](#input\_host\_network)

Description: Set to true to enable host networking mode

Type: `bool`

Default: `null`

### <a name="input_image"></a> [image](#input\_image)

Description:   The configuration for which image and how to handle it.  
  This includes the pull policy and the URI of the image.

  If `uri` is set then this is used. Otherwise set the `repo`, `registry`, and `tag` to build the URI. If none of these values are set, then it's assumed the app name is the repo, the registry is docker.io, and the tag is latest, ie `docker.io/myapp:latest`.

  The `pullPolicy` field determines how the image is pulled. It can be one of the following: `Always`, `IfNotPresent`, or `Never`. Default is `IfNotPresent`.

  The `managed` field determines if the images is updated by Terraform or not. If it is not managed, the image will not be updated by Terraform and it's expected you are using the duploctl CLI to update the image. Defaults to true.

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

  The `timeout` field will determine the timeout for the job. If the field is not set, the timeout will be 60 seconds.

  The `labels` field will determine the labels to add to the job. If the field is not set, the labels will be an empty map. These are applied to the job and on the pod merged with pod labels.

  The `annotations` field will determine the annotations to add to the job. If the field is not set, the annotations will be an empty map. These are applied to the job and on the pod merged with pod annotations.

  The `env` field will determine the environment variables to add to the job. If the field is not set, the env will be an empty map. These are applied to the job and on the pod merged with pod env.

Type:

```hcl
list(object({
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
```

Default: `[]`

### <a name="input_labels"></a> [labels](#input\_labels)

Description: Labels to add to the service.

Type: `map(string)`

Default: `{}`

### <a name="input_lb"></a> [lb](#input\_lb)

Description: Expose the service via a load balancer.

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

Type:

```hcl
object({
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
```

Default: `{}`

### <a name="input_nodes"></a> [nodes](#input\_nodes)

Description:   The configuration for which nodes to run the service on.

  The `shared` field will determine if the service can run on shared nodes or not. If the field is not set, the service will only run on nodes within its own tenant.

  The `allocation_tags` field is a list of tags to use for allocating the nodes. If the field is not set, the service will run on any node within a tenant. If the `shared` field is set, then the allocation\_tags may be ones from another tenant sharing it's nodes.

  The `selector` field is a map of labels to use for selecting the nodes. If the field is not set, the service will run on any node within a tenant. If the `shared` field is set, then the selector may use labels on nodes from tenants sharing their nodes.

  The `unique` field will determine if the service should run on a unique node or not. This will treat a normal service kind of like a daemonset. In the background, the pod is asking to be on nodes which don't have one of itself already on it.

  The `spread_across_zones` field will determine if the service should be spread across zones or not. The scheduler will pick the least used node it can which might be another node in a zone that already has one of itself. This ensures the scheduler will also consider the least used zone it can.

Type:

```hcl
object({
    shared              = optional(bool, false)
    allocation_tags     = optional(string, null)
    selector            = optional(map(string), null)
    unique              = optional(bool, false)
    spread_across_zones = optional(bool, false)
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
  This includes the replicas, min, max, and the metrics for determining how to auto scale.

  The metrics field is a list of metrics to use for autoscaling. Auto scaling is considered `enabled` when there are metrics, if there are none then the service will only use the replica count. See [Kubernetes Horizontal Pod Autoscale Walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) for more information.

  The behavior field tunes how quickly the autoscaler reacts, using the scaleUp and scaleDown blocks of the HPA behavior spec. It only takes effect when metrics are set. See [Configurable scaling behavior](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior).

Type:

```hcl
object({
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
    behavior = optional(object({
      scaleUp = optional(object({
        stabilizationWindowSeconds = optional(number)
        selectPolicy               = optional(string)
        policies = optional(list(object({
          type          = string
          value         = number
          periodSeconds = number
        })), [])
      }), {})
      scaleDown = optional(object({
        stabilizationWindowSeconds = optional(number)
        selectPolicy               = optional(string)
        policies = optional(list(object({
          type          = string
          value         = number
          periodSeconds = number
        })), [])
      }), {})
    }), {})
  })
```

Default: `{}`

### <a name="input_secrets"></a> [secrets](#input\_secrets)

Description: The list of external secret names to be mounted as envFrom.

Type: `list(string)`

Default: `[]`

### <a name="input_security_context"></a> [security\_context](#input\_security\_context)

Description:   The pod-level security context (Kubernetes `PodSecurityContext`) for the service.

  The `run_as_user`, `run_as_group`, and `fs_group` fields map to the Kubernetes
  `runAsUser`, `runAsGroup`, and `fsGroup` fields respectively.

  The `run_as_non_root` field maps to `runAsNonRoot`.

  The `seccomp_profile` field maps to `seccompProfile`, with `type` being one of
  `RuntimeDefault`, `Localhost`, or `Unconfined`. `localhost_profile` is only used when
  `type` is `Localhost` and is the path to the profile on the node, relative to the  
  kubelet's configured seccomp profile location.

Type:

```hcl
object({
    run_as_user     = optional(number, null)
    run_as_group    = optional(number, null)
    fs_group        = optional(number, null)
    run_as_non_root = optional(bool, null)
    seccomp_profile = optional(object({
      type              = string
      localhost_profile = optional(string, null)
    }), null)
  })
```

Default: `null`

### <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name)

Description: The service account name for the service

Type: `string`

Default: `null`

### <a name="input_sidecars"></a> [sidecars](#input\_sidecars)

Description:   Sidecars for the service. These are additional containers that run alongside the main container in the pod.

  The `name` field is the name of the sidecar.

  The `image` field is the image to use for the sidecar. If the field is not set, the image will be "duplocloud/sidecar:latest".

  The `command` field is the command to run in the sidecar. If the field is not set, the command will be an empty list.

  The `args` field is the arguments to pass to the command. If the field is not set, the args will be an empty list.

  The `env` field is a map of environment variables to set on the sidecar. If the field is not set, the env will be an empty map.

  The `resources` field is a map of resource requests and limits for the sidecar. If the field is not set, the resources will be an empty map.

  The `security_context` field is an object with run\_as\_user, run\_as\_group, and run\_as\_non\_root  
  fields, mapping to the Kubernetes container `securityContext`'s `runAsUser`, `runAsGroup`, and
  `runAsNonRoot` fields. If the field is not set, it will be null. `fs_group` is not supported here  
  since `fsGroup` is only valid on the pod-level `securityContext` — use the top-level
  `security_context` variable's `fs_group` instead, which applies to every container in the pod.

  The `ports` field is a list of ports to expose on the sidecar. If the field is not set, the ports will be an empty list.

  The `volume_mounts` field is a list of volume mounts to add to the sidecar. If the field is not set, the volume mounts will be an empty list.

Type:

```hcl
set(object({
    name    = string
    image   = string
    command = optional(list(string), [])
    args    = optional(list(string), [])
    env     = optional(map(string), {})
    resources = optional(object({
      requests = optional(map(string))
      limits   = optional(map(string))
    }), null)
    security_context = optional(object({
      run_as_user     = optional(number, null)
      run_as_group    = optional(number, null)
      run_as_non_root = optional(bool, null)
    }), null)
    ports = optional(list(object({
      name          = string
      containerPort = number
      protocol      = optional(string, "TCP")
    })), [])
    volume_mounts = optional(list(object({
      name      = string
      mountPath = string
      readOnly  = optional(bool, false)
      subPath   = optional(string, null)
    })), [])
  }))
```

Default: `[]`

### <a name="input_termination_grace_period"></a> [termination\_grace\_period](#input\_termination\_grace\_period)

Description: The amount of time to wait, in seconds, for pod activity to terminate gracefully after shutdown signal

Type: `number`

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

### <a name="output_domain"></a> [domain](#output\_domain)

Description: The fully qualified domain name of the service.

### <a name="output_image"></a> [image](#output\_image)

Description: The actual image in use atm.

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the service.

### <a name="output_namespace"></a> [namespace](#output\_namespace)

Description: The namespace within kubernetes this service is in.

### <a name="output_parent_domain"></a> [parent\_domain](#output\_parent\_domain)

Description: The parent domain of the service.

### <a name="output_release_header"></a> [release\_header](#output\_release\_header)

Description: This is an object with name and value. The name is the header name and the value is header value which is the value of the release\_id.

### <a name="output_release_id"></a> [release\_id](#output\_release\_id)

Description: The random release id for this deployment.

### <a name="output_volumes"></a> [volumes](#output\_volumes)

Description: The list of volumes mounted to the service.
<!-- END_TF_DOCS -->
