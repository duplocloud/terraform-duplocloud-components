# Tenant Data - AWS

Being inside a DuploCloud tenant gives you a lot of information. It can tell you the name or ARN of the IAM role used by resources in the tenant, the DNS domain where the portal will make records for your load balancers, the IDs of your private subnets, and many other things.

This is a [data-only module](https://developer.hashicorp.com/terraform/language/modules/develop/composition#data-only-modules) that condenses the available data into values structured for DuploCloud Terraform on AWS.

This module only outputs values that are uniquely determined by a DuploCloud tenant. It doesn't include the VPN IP. The VPN may be in a different region than the tenant where this module is run and can't be looked up without provider config that goes beyond the boundary of the tenant.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_certificate_enabled"></a> [default\_certificate\_enabled](#input\_default\_certificate\_enabled) | Is the default certficiate enabled in the portal? Usually true. | `bool` | `true` | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | Name (not ID) of the tenant. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | ID of the AWS account where the tenant's DuploCloud portal runs. |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region where the tenant's resources will be deployed. |
| <a name="output_default_certificate_arn"></a> [default\_certificate\_arn](#output\_default\_certificate\_arn) | ARN of the `duplo-default/.domain.example.com` ACM certificate created automatically by the DuploCloud portal. |
| <a name="output_dns_domain"></a> [dns\_domain](#output\_dns\_domain) | External DNS domain of the tenant's infrastructure with no leading or trailing period. |
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | ID of the Route53 hosted zone of dns\_domain. |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the tenant's IAM role. |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the tenant's IAM role. |
| <a name="output_nat_ips"></a> [nat\_ips](#output\_nat\_ips) | NAT gateway IPs. Use these for whitelisting traffic that comes from tenant resources. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of the IDs of the private subnets in the tenant's infrastructure. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of the IDs of the public subnets in the tenant's infrastructure. |
| <a name="output_raw"></a> [raw](#output\_raw) | Raw data. Use these if no other output has what you need. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the tenant's security group. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the tenant's security group. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the tenant's security group. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | ID of the tenant. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC managed by the tenant's infrastructure. |
<!-- END_TF_DOCS -->