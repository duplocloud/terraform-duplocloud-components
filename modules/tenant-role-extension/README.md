## Example 
```
locals {
  my_secrets_prefix = "SecretSauce"
  tenant_name = "dev01"
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}


data "aws_iam_policy_document" "example" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${local.aws_account_id}:secret:/${local.my_secrets_prefix}/*"]
  }
}

module "tenant-role" {
  source          = "duplocloud/components/duplocloud//modules/tenant-role-extension"
  version         = "0.0.19"
  tenant_name     = local.tenant_name
  iam_policy_json = data.aws_iam_policy_document.example.json
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) | ~> 0.9.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Notes
This module adds a given permissions policy to the DuploCloud IAM role. If modifying the assume role policy to permit AWS services to use the tenant role, you must manually edit the assume role policy in the console. Make sure you create a new SID for the new assume role policy, and ensure it does not start with "duplo".

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.custom_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_policy_json"></a> [iam\_policy\_json](#input\_iam\_policy\_json) | The IAM policy JSON which has the extra policies granted to the tenant role | `any` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The name for the custom IAM policy created | `string` | `"custom-policy"` | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The tenant name for which to extend the IAM role | `any` | n/a | yes |

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.4.4)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (>= 5.12.0)

- <a name="requirement_duplocloud"></a> [duplocloud](#requirement\_duplocloud) (>= 0.9.40)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (5.12.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_iam_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_role_policy_attachment.custom_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_iam_policy_json"></a> [iam\_policy\_json](#input\_iam\_policy\_json)

Description: The IAM policy JSON which has the extra policies granted to the tenant role

Type: `string`

### <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name)

Description: The tenant name for which to extend the IAM role

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name)

Description: The name for the custom IAM policy created

Type: `string`

Default: `"custom-policy"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->


## Submodules

This module is a combination of the following submodules so that Github, AWS, and Duplocloud  [tenant](../tenant/README.md) can all be synchronized together. The github integration is baked into this one. 

> [!IMPORTANT]  
> See this if need to migrate `tenant` to `tenant-role-extension`.   
> [Move tenant to tenant-role-extension](../tenant/README.md#import-tenant-to-tenant-gh) 