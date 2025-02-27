# Standalone ALB  

Creates a standalone ALB with a static health check at `/`. This is meant to be provisioned before any services are available in an `aws-services` root module. Once provisioned each needed service can be loaded up with a target group and attached to this. Ideally the service module will output this listener arn as it is needed to attach to a specific services target group.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.9.40)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (0.9.45)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [duplocloud_aws_lb_listener_rule.default](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_lb_listener_rule) (resource)
- [duplocloud_aws_lb_target_group.default](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_lb_target_group) (resource)
- [duplocloud_aws_load_balancer.standalone](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_load_balancer) (resource)
- [duplocloud_aws_load_balancer_listener.https](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_load_balancer_listener) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cert_arn"></a> [cert\_arn](#input\_cert\_arn)

Description: The ARN of the certificate to use for HTTPS listeners.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The display name to use for the ALB

Type: `string`

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: The tenant object the ALB will be added to.

Type: `string`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: The VPC ID to use for the ALB.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_health_path"></a> [health\_path](#input\_health\_path)

Description: The path to use for the health check. This is for the static response rule.

Type: `string`

Default: `"/health"`

### <a name="input_timeout"></a> [timeout](#input\_timeout)

Description: The idle timeout value, in seconds. The valid range is 1-4000 seconds. The default is 60 seconds.

Type: `number`

Default: `60`

## Outputs

The following outputs are exported:

### <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn)

Description: The ARN of the ALB.

### <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn)

Description: The https listener ARN for target groups to connect with.
<!-- END_TF_DOCS -->

