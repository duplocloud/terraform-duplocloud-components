# Gamelift Build  

Creates a Gamelift build based on an S3 artifact. Then a fleet is created with the build.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) (1.10.0)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.35)

## Providers

The following providers are used by this module:

- <a name="provider_awscc"></a> [awscc](#provider\_awscc) (1.10.0)

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (>= 0.10.35)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [awscc_gamelift_build.this](https://registry.terraform.io/providers/hashicorp/awscc/1.10.0/docs/resources/gamelift_build) (resource)
- [awscc_gamelift_fleet.this](https://registry.terraform.io/providers/hashicorp/awscc/1.10.0/docs/resources/gamelift_fleet) (resource)
- [duplocloud_aws_account.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/aws_account) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_build"></a> [build](#input\_build)

Description: The build to deploy

Type:

```hcl
object({
    version            = string
    bucket             = string
    operating_system   = optional(string, "AMAZON_LINUX_2")
    bucket_tenant_name = optional(string, "devops")
    bucket_key         = optional(string)
  })
```

### <a name="input_fleet"></a> [fleet](#input\_fleet)

Description: The fleet to deploy the build to

Type:

```hcl
object({
    type                               = optional(string, "ON_DEMAND")
    new_game_session_protection_policy = optional(string, "FullProtection")
    launch_path                        = optional(string)
    parameters                         = optional(string)
    compute_type                       = optional(string, "EC2")
    ec2_instance_type                  = optional(string, "c4.large")
    ec2_inbound_permissions = optional(list(object({
      from_port = number
      to_port   = number
      protocol  = string
      ip_range  = string
    })))
    locations = optional(list(object({
      location = string
      priority = number
    })))
  })
```

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the application. The build name will be this name with the version appended

Type: `string`

### <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name)

Description: The tenant this build will be deployed into

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_build_id"></a> [build\_id](#output\_build\_id)

Description: n/a

### <a name="output_fleet_id"></a> [fleet\_id](#output\_fleet\_id)

Description: n/a
<!-- END_TF_DOCS -->

