# VPN Data - AWS

This is a [data-only module](https://developer.hashicorp.com/terraform/language/modules/develop/composition#data-only-modules) that checks if the DuploCloud VPN is enabled and outputs its IP addresses if it is.

To use this module, [pass](https://developer.hashicorp.com/terraform/language/modules/develop/providers#passing-providers-explicitly) it a `vpn_region` AWS provider configuration for the region where the VPN is deployed (almost always the default region of the DuploCloud portal):
```
data "duplocloud_admin_aws_credentials" "current" {}

provider "aws" {
  alias = "portal_default_region"

  region     = data.duplocloud_admin_aws_credentials.current.region
  access_key = data.duplocloud_admin_aws_credentials.current.access_key_id
  secret_key = data.duplocloud_admin_aws_credentials.current.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.current.session_token
}

module "vpn_data" {
  source = "../../modules/vpn-data-aws"

  providers = {
    aws.vpn_region = aws.portal_default_region
  }
}
```

For other regions (`us-east-1` in this example):
```
data "duplocloud_admin_aws_credentials" "current" {}

provider "aws" {
  alias = "vpn_region"

  region     = "us-east-1"
  access_key = data.duplocloud_admin_aws_credentials.current.access_key_id
  secret_key = data.duplocloud_admin_aws_credentials.current.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.current.session_token
}

module "vpn_data" {
  source = "../../modules/vpn-data-aws"

  providers = {
    aws.vpn_region = aws.vpn_region
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | Name of the CloudFormation stack managing the VPN. | `string` | `"duplo-openvpn-v1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether or not the VPN is enabled for this portal. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP address of the VPN (if it exists). |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP address of the VPN (if it exists). |
<!-- END_TF_DOCS -->