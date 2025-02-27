# ReTool Bastion Server  

DuploCloud creates all services as private. This means ReTool in the cloud can't directly access your database. To gain access to your database, you need a bastion server. This server will act as a bridge between ReTool and your private database. This setup can be used for any private resources, not just databases.

## Variables  

| Name | Description | Required | Default |  
|------|-------------|----------| ------- |  
| `tenant_id` | Tenant ID | true | |  
| `name` | Name of the bastion server | false | `retool-bastion` |  
| `capacity` | Capacity of the bastion server | false | `t3.small` |  
| `retool_public_key` | Public key of the ReTool server | true | |  

## Configuring Retool  

When adding a data source to Retool, notice there is an advanced section where you can configure an SSH tunnel. The bastion host will be the public IP address or the DNS name provided by AWS on this host. Download the provided public key on the ssh tunnel configuration, this is unique to your account. You will want to save this somewhere safe, maybe SSM Parameter Store, then reference it in your own Terraform module. 

The topology for this looks like this:  
```
(Retool) --ssh-tunnel--> (bastion server) --port-forward--> (RDS PostgreSQL)
```

## Example Usage

Here is a simple example of how to use this module.  
```hcl
module "retool-bastion" {
  source  = "duplocloud/components/duplocloud//modules/retool-bastion"
  version = "0.0.17"
  tenant_id = local.tenant_id
  retool_public_key = local.retool_public_key
}
```

Also see the [retool-bastion example](examples/retool-bastion) directory to see a fully working example.

## References

 - [Configure SSH tunneling for resources](https://docs.retool.com/data-sources/guides/ssh-tunnels)

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (>= 5.12.0)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.34)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (5.68.0)

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (0.10.48)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_api_gateway_base_path_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) (resource)
- [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) (resource)
- [aws_api_gateway_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) (resource)
- [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) (resource)
- [aws_api_gateway_stage.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) (resource)
- [aws_api_gateway_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_vpc_link) (resource)
- [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) (resource)
- [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) (resource)
- [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) (resource)
- [aws_apigatewayv2_stage.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) (resource)
- [aws_apigatewayv2_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link) (resource)
- [aws_cloudwatch_log_group.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) (resource)
- [aws_route53_record.http_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)
- [aws_route53_record.rest_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)
- [duplocloud_aws_lambda_permission.permission](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_lambda_permission) (resource)
- [aws_security_group.tenant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) (data source)
- [duplocloud_aws_account.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/aws_account) (data source)
- [duplocloud_infrastructure.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/infrastructure) (data source)
- [duplocloud_plan_certificate.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/plan_certificate) (data source)
- [duplocloud_plan_settings.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/plan_settings) (data source)
- [duplocloud_tenant.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant) (data source)
- [duplocloud_tenant_internal_subnets.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant_internal_subnets) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name)

Description: The name of the certificate

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the API Gateway

Type: `string`

### <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_body"></a> [body](#input\_body)

Description: The body of the api gateway as a string

Type: `string`

Default: `null`

### <a name="input_enable_private_link"></a> [enable\_private\_link](#input\_enable\_private\_link)

Description: Enable private link for the gateway

Type: `bool`

Default: `false`

### <a name="input_openapi_file"></a> [openapi\_file](#input\_openapi\_file)

Description: Filepath to the open api file. Use interchangeably with providing the string in 'body'

Type: `string`

Default: `null`

### <a name="input_openapi_variables"></a> [openapi\_variables](#input\_openapi\_variables)

Description: Extra parameters required for the open api template file that are not account id, duplo tenant, the domain, or the aws region

Type: `map(any)`

Default: `{}`

### <a name="input_subdomain"></a> [subdomain](#input\_subdomain)

Description: The subdomain as the prefix on the base domain

Type: `string`

Default: `null`

### <a name="input_type"></a> [type](#input\_type)

Description: The type of api gateway

Type: `string`

Default: `"http"`

### <a name="input_vpc_link_targets"></a> [vpc\_link\_targets](#input\_vpc\_link\_targets)

Description: The list of vpc link targets when type is not http, ie rest, private-rest, or socket

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_api_id"></a> [api\_id](#output\_api\_id)

Description: The ID of the API Gateway

### <a name="output_domain"></a> [domain](#output\_domain)

Description: n/a
<!-- END_TF_DOCS -->
