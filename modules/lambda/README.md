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

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.34)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (>= 0.10.34)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [duplocloud_aws_lambda_function.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_lambda_function) (resource)
- [duplocloud_tenant.this](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_handler"></a> [handler](#input\_handler)

Description: The handler for the lambda

Type: `string`

### <a name="input_image"></a> [image](#input\_image)

Description: n/a

Type:

```hcl
object({
    uri               = string
    entry_point       = optional(list(string))
    working_directory = optional(string)
  })
```

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the lambda

Type: `string`

### <a name="input_package_type"></a> [package\_type](#input\_package\_type)

Description: The type of package to deploy

Type: `string`

### <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_description"></a> [description](#input\_description)

Description: n/a

Type: `string`

Default: `"Duplocloud Rocks"`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: The environment variables for the lambda

Type: `map(string)`

Default: `{}`

### <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size)

Description: The memory size for the lambda

Type: `number`

Default: `2048`

### <a name="input_timeout"></a> [timeout](#input\_timeout)

Description: The timeout for the lambda

Type: `number`

Default: `600`

### <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode)

Description: The tracing mode for the lambda

Type: `string`

Default: `"PassThrough"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->