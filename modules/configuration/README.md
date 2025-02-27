# Duplo Configuration Module 

Builds a configuration a number of ways for an application. 

## Classes  

Each class is a different way to build a configuration. The following sections details the different classes. To set the class, use the `class` variable as an input. The default is `configmap`. 

Options for `class` are:  
- `configmap`  
- `secret`
- `aws-secret`
- `aws-ssm`

## CSI Support  

If your cluster has the aws csi driver for secrets enabled, then this can be true. When true you can use `aws-secret` or `aws-ssm` as the class.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.40)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (0.11.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [duplocloud_aws_ssm_parameter.managed](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_ssm_parameter) (resource)
- [duplocloud_aws_ssm_parameter.unmanaged](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_ssm_parameter) (resource)
- [duplocloud_k8_config_map.managed](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8_config_map) (resource)
- [duplocloud_k8_config_map.unmanaged](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8_config_map) (resource)
- [duplocloud_k8_secret.managed](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8_secret) (resource)
- [duplocloud_k8_secret.unmanaged](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8_secret) (resource)
- [duplocloud_k8_secret_provider_class.aws](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/k8_secret_provider_class) (resource)
- [duplocloud_tenant_secret.managed](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/tenant_secret) (resource)
- [duplocloud_tenant_secret.unmanaged](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/tenant_secret) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: The tenant id.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_class"></a> [class](#input\_class)

Description: The class of the config.

Type: `string`

Default: `"configmap"`

### <a name="input_csi"></a> [csi](#input\_csi)

Description: Whether to use the csi driver and bind to a kubernetes secret. Only available for aws-secret and aws-ssm.

Type: `bool`

Default: `false`

### <a name="input_data"></a> [data](#input\_data)

Description: The map of key/values for the configuration.

Type: `map(string)`

Default: `{}`

### <a name="input_description"></a> [description](#input\_description)

Description: The description of the configuration.

Type: `string`

Default: `null`

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Whether the configuration is enabled on a service.

Type: `bool`

Default: `true`

### <a name="input_managed"></a> [managed](#input\_managed)

Description: Whether terraform should manage the value of the data. If false, the data will be ignored.

Type: `bool`

Default: `true`

### <a name="input_mountPath"></a> [mountPath](#input\_mountPath)

Description: The mount path of the configuration. Only available for files and when csi is enabled.

Type: `string`

Default: `null`

### <a name="input_name"></a> [name](#input\_name)

Description: The simple name of the config. This name is used on volumes/volumeMounts as the name.

Type: `string`

Default: `null`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: An optional prefix for the name with a dash. This is ideal if the name comes from the higher level resource/module, e.g. the app name.

Type: `string`

Default: `null`

### <a name="input_type"></a> [type](#input\_type)

Description: The type of the config. This is used to determine how the config will be used.

Type: `string`

Default: `"environment"`

### <a name="input_value"></a> [value](#input\_value)

Description: The string value of the configuration. Use either data or value, not both. This will take precedence over data if it is set.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_class"></a> [class](#output\_class)

Description: The class of the configuration.

### <a name="output_csi"></a> [csi](#output\_csi)

Description: Whether or not the configuration is a CSI configuration. This may be different than the input because some classes don't support CSI.

### <a name="output_enabled"></a> [enabled](#output\_enabled)

Description: Whether or not the configuration is enabled.

### <a name="output_envFrom"></a> [envFrom](#output\_envFrom)

Description: The envFrom configuration if the configuration is of type environment and enabled.

### <a name="output_id"></a> [id](#output\_id)

Description: The ID of the configuration. This is only used for the name of a volume mounted on a service.

### <a name="output_name"></a> [name](#output\_name)

Description: The actual name of the configuration.

### <a name="output_type"></a> [type](#output\_type)

Description: The type configuration.

### <a name="output_volume"></a> [volume](#output\_volume)

Description: The volume configuration if the configuration is of type files and enabled. Even when type is environment, if csi is enabled then a volume is also needed.

### <a name="output_volumeMount"></a> [volumeMount](#output\_volumeMount)

Description: The volume mount configuration if the configuration is of type files and enabled. Even when type is environment, if csi is enabled then a volume mount is also needed.
<!-- END_TF_DOCS -->
