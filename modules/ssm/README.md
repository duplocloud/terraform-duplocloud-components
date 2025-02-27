<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.34)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (>= 0.10.34)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [duplocloud_aws_ssm_parameter.ssm_param](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_ssm_parameter) (resource)
- [duplocloud_tenant.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_parameters"></a> [parameters](#input\_parameters)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    type  = optional(string, "SecureString")
    value = string
  }))
```

Default: `[]`

## Outputs

No outputs.
<!-- END_TF_DOCS -->