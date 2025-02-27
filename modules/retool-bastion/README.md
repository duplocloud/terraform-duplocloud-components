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

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.9.40)

## Providers

The following providers are used by this module:

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (>= 0.9.40)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [duplocloud_aws_host.bastion](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/aws_host) (resource)
- [duplocloud_native_host_images.current](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/native_host_images) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_retool_public_key"></a> [retool\_public\_key](#input\_retool\_public\_key)

Description: The public key for the retool user

Type: `string`

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_capacity"></a> [capacity](#input\_capacity)

Description: The size of the instance

Type: `string`

Default: `"t3.small"`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the instance

Type: `string`

Default: `"retool-bastion"`

## Outputs

The following outputs are exported:

### <a name="output_host"></a> [host](#output\_host)

Description: n/a
<!-- END_TF_DOCS -->
