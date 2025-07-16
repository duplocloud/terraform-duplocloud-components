# EKS HA Nodes  

Creates duplocloud EKS hosts for a tenant. This creates an HA setup on at least two zones. This will optionally also do a full rollover to new hosts using the Duplo ASG refresh feature.

## Example  

Here is a simple example used often. 

```hcl
module "nodegroup" {
  source             = "duplocloud/components/duplocloud//modules/eks-nodes"
  version            = "0.0.5"
  tenant_id          = local.tenant_id
  capacity           = var.asg_capacity
  eks_version        = local.eks_version
  instance_count     = var.asg_instance_count
  min_instance_count = var.asg_min_instance_count
  max_instance_count = var.asg_max_instance_count
  os_disk_size       = var.asg_os_disk_size
}
```

## Testing  

Run the unit tests with: 
```sh
terraform test -filter=tests/unit.tftests.hcl
```

Run the integration tests with: 
```sh
terraform test -filter=tests/integration.tftests.hcl
```

## References  
  - [Duploclud Hosts](https://docs.duplocloud.com/docs/azure/use-cases/hosts-vms)
  - [Duplocloud ASG](https://docs.duplocloud.com/docs/aws/use-cases/auto-scaling/auto-scaling-groups)

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (>= 5.12.0)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.10.24)

- <a name="requirement_null"></a> [null](#requirement\_null) (>= 3.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (5.74.0)

- <a name="provider_duplocloud"></a> [duplocloud](#provider\_duplocloud) (0.10.50)

- <a name="provider_null"></a> [null](#provider\_null) (3.2.3)

- <a name="provider_random"></a> [random](#provider\_random) (3.6.3)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [duplocloud_asg_profile.nodes](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/asg_profile) (resource)
- [null_resource.create_script](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [null_resource.destroy_script](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [random_integer.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [aws_ami.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_asg_ami"></a> [asg\_ami](#input\_asg\_ami)

Description: Set AMI to static value

Type: `string`

Default: `null`

### <a name="input_az_list"></a> [az\_list](#input\_az\_list)

Description: The letter at the end of the zone

Type: `list(string)`

Default:

```json
[
  "a",
  "b"
]
```

### <a name="input_base_ami_name"></a> [base\_ami\_name](#input\_base\_ami\_name)

Description: n/a

Type: `string`

Default: `"amazon-eks-node"`

### <a name="input_can_scale_from_zero"></a> [can\_scale\_from\_zero](#input\_can\_scale\_from\_zero)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_capacity"></a> [capacity](#input\_capacity)

Description: n/a

Type: `string`

Default: `"t3.medium"`

### <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version)

Description: n/a

Type: `string`

Default: `"1.24"`

### <a name="input_encrypt_disk"></a> [encrypt\_disk](#input\_encrypt\_disk)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_is_ebs_optimized"></a> [is\_ebs\_optimized](#input\_is\_ebs\_optimized)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count)

Description: n/a

Type: `number`

Default: `3`

### <a name="input_max_spot_price"></a> [max\_spot\_price](#input\_max\_spot\_price)

Description: Maximum price to pay for a spot instance in dollars per unit hour, such as 0.40

Type: `string`

Default: `null`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata to apply to the Duplo Minions

Type: `map(string)`

Default: `{}`

### <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_minion_tags"></a> [minion\_tags](#input\_minion\_tags)

Description: Tags to apply to the Duplo Minions

Type: `map(string)`

Default: `{}`

### <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size)

Description: n/a

Type: `number`

Default: `20`

### <a name="input_pod_rollover"></a> [pod\_rollover](#input\_pod\_rollover)

Description: Enable/Disable kubectl drain option.

Type: `bool`

Default: `false`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: n/a

Type: `string`

Default: `"apps-"`

### <a name="input_rollover_timeout"></a> [rollover\_timeout](#input\_rollover\_timeout)

Description: Time for the kubectl drain to run before timing out.

Type: `number`

Default: `120`

### <a name="input_use_spot_instances"></a> [use\_spot\_instances](#input\_use\_spot\_instances)

Description: n/a

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_node_ami"></a> [node\_ami](#output\_node\_ami)

Description: n/a

### <a name="output_nodes"></a> [nodes](#output\_nodes)

Description: n/a
<!-- END_TF_DOCS -->

