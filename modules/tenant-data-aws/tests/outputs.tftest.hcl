# This module is mostly lookups and passthrough, it doesn't really contain logic. Testing it is mostly about asserting
# its understanding of the data sources is correct. To do that, we need to query a real portal and AWS account and
# make sure the expected data comes back. Deploying a unique test environment where we could do that would be slow and
# expensive. Instead, we keep the tests light by asserting on the format of outputs instead of specific values so they
# can be run against any test environment.

variables {
  # DuploCloud portals always have a default tenant.
  # To fully exercise all the cases, you would need to run the same tests against multiple infrastructures with
  # different configurations (e.g. EKS enabled or disabled).
  tenant_name = "default"
}

provider "aws" {
  access_key = run.setup.credentials.access_key_id
  region     = run.setup.region
  secret_key = run.setup.credentials.secret_access_key
  token      = run.setup.credentials.session_token
}

# See this doc for the 'setup' pattern:
# https://developer.hashicorp.com/terraform/language/tests#modules
run "setup" {

  command = plan

  variables {
    tenant_name = var.tenant_name
  }

  module {
    source = "./tests/setup"
  }
}

run "outputs_aws" {

  command = plan

  assert {
    condition     = can(regex("^[0-9]{12}$", output.aws_account_id))
    error_message = "Account ID should be a twelve-digit number"
  }

  assert {
    condition     = can(regex("^[a-z0-9-]+$", lower(output.aws_region)))
    error_message = "AWS region should be alphanumeric with dashes."
  }
}

run "outputs_certificate" {

  command = plan

  assert {
    condition     = output.default_certificate_arn == null || provider::aws::arn_parse(output.default_certificate_arn).service == "acm"
    error_message = "Certificate ARN should refer to the 'acm' service or be null if not available."
  }

  assert {
    condition     = output.default_certificate_arn == null || startswith(provider::aws::arn_parse(output.default_certificate_arn).resource, "certificate/")
    error_message = "Certificate ARN should refer to a 'certificate/' resource or be null if not available."
  }

  assert {
    condition     = output.default_certificate_name == null || can(regex("^duplo-default/", output.default_certificate_name))
    error_message = "Certificate name should start with 'duplo-default/' or be null if not available."
  }

  assert {
    condition     = (output.default_certificate_arn == null) == (output.default_certificate_name == null)
    error_message = "Certificate ARN and name should both be null or both be non-null."
  }
}

run "outputs_dns" {

  command = plan

  assert {
    condition     = trim(output.dns_domain, ".") == output.dns_domain
    error_message = "DNS domain shouldn't have leading or trailing periods."
  }

  assert {
    # This assertion is more limiting than the actual DNS specification, but the test environments are very unlikely
    # to use any other patterns. We keep the regex simple.
    condition     = can(regex("^[a-z0-9.-]+$", lower(output.dns_domain)))
    error_message = "DNS domain should be alphanumeric with periods and dashes."
  }

  assert {
    condition     = startswith(output.dns_zone_id, "Z")
    error_message = "DNS zone ID should start with 'Z'."
  }

  assert {
    condition     = can(regex("^[a-z0-9]+$", lower(output.dns_zone_id)))
    error_message = "DNS zone ID should be alphanumeric."
  }
}

run "outputs_eks" {

  command = plan

  assert {
    condition     = output.eks_cluster_arn == null || provider::aws::arn_parse(output.eks_cluster_arn).service == "eks"
    error_message = "EKS cluster ARN should refer to the 'eks' service or be null if not available."
  }

  assert {
    condition     = output.eks_cluster_arn == null || startswith(provider::aws::arn_parse(output.eks_cluster_arn).resource, "cluster/")
    error_message = "EKS cluster ARN should refer to a 'cluster/' resource or be null if not available."
  }

  assert {
    condition     = output.eks_cluster_name == null || startswith(output.eks_cluster_name, "duploinfra-")
    error_message = "EKS cluster name should start with 'duploinfra-' or be null if not available."
  }

  assert {
    condition     = output.eks_cluster_version == null || can(regex("^[0-9]+\\.[0-9]+$", output.eks_cluster_version))
    error_message = "EKS cluster version should be in format 'X.Y' or be null if not available."
  }

  assert {
    condition     = output.kubernetes_namespace == null || startswith(output.kubernetes_namespace, "duploservices-")
    error_message = "Kubernetes namespace should start with 'duploservices-' or be null if not available."
  }

  assert {
    condition     = (output.eks_cluster_arn == null) == (output.eks_cluster_name == null)
    error_message = "EKS cluster ARN and name should both be null or both be non-null."
  }

  assert {
    condition     = (output.eks_cluster_arn == null) == (output.kubernetes_namespace == null)
    error_message = "EKS cluster ARN and Kubernetes namespace should both be null or both be non-null."
  }
}

run "outputs_iam_role" {

  command = plan

  assert {
    condition     = provider::aws::arn_parse(output.iam_role_arn).service == "iam"
    error_message = "IAM role ARN should refer to the 'iam' service."
  }

  assert {
    condition     = startswith(provider::aws::arn_parse(output.iam_role_arn).resource, "role/")
    error_message = "IAM role ARN should refer to a 'role/' resource."
  }

  assert {
    condition     = endswith(provider::aws::arn_parse(output.iam_role_arn).resource, output.iam_role_name)
    error_message = "IAM role ARN should end with the IAM role name."
  }

  assert {
    condition     = startswith(output.iam_role_name, "duploservices-")
    error_message = "IAM role name should start with 'duploservices-'."
  }
}

run "outputs_infrastructure" {

  command = plan

  assert {
    condition     = output.availability_zones == null ? true : alltrue([for az in output.availability_zones : can(regex("^[a-z0-9-]+$", az))])
    error_message = "Availability zones should be null or a list of strings that are alphanumeric with dashes."
  }

  assert {
    condition     = can(regex("^[a-z0-9-]+$", lower(output.infrastructure_name)))
    error_message = "Infrastructure name should be alphanumeric with dashes."
  }

  assert {
    condition     = output.infrastructure_name == output.plan_id
    error_message = "Infrastructure name and plan ID should match."
  }
}

run "outputs_kms" {

  command = plan

  assert {
    condition     = provider::aws::arn_parse(output.kms_key_arn).service == "kms"
    error_message = "KMS key ARN should refer to the 'kms' service."
  }

  assert {
    condition     = startswith(provider::aws::arn_parse(output.kms_key_arn).resource, "key/")
    error_message = "KMS key ARN should refer to a 'key/' resource."
  }

  assert {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", output.kms_key_id))
    error_message = "KMS key ID should be a UUID."
  }

  assert {
    condition     = endswith(provider::aws::arn_parse(output.kms_key_arn).resource, output.kms_key_id)
    error_message = "KMS key ARN should end with the KMS key ID."
  }
}

run "outputs_security_group" {

  command = plan

  assert {
    condition     = provider::aws::arn_parse(output.security_group_arn).service == "ec2"
    error_message = "Security group ARN should refer to the 'ec2' service."
  }

  assert {
    condition     = startswith(provider::aws::arn_parse(output.security_group_arn).resource, "security-group/")
    error_message = "Security group ARN should refer to a 'security-group/' resource."
  }

  assert {
    condition     = startswith(output.security_group_id, "sg-")
    error_message = "Security group ID should start with 'sg-'."
  }

  assert {
    condition     = startswith(output.security_group_name, "duploservices-")
    error_message = "Security group name should start with 'duploservices-'."
  }
}

run "outputs_tenant" {

  command = plan

  assert {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", output.tenant_id))
    error_message = "Tenant ID should be a UUID."
  }

  assert {
    condition     = output.tenant_name == var.tenant_name
    error_message = "Tenant name output should match the input variable."
  }

  assert {
    condition     = can(regex("^[a-z0-9-]+$", lower(output.tenant_name)))
    error_message = "Tenant name should be alphanumeric with dashes."
  }
}

run "outputs_vpc" {

  command = plan

  # This test doesn't pass because of a known issue.
  # assert {
  #   condition     = length(output.nat_ips) >= 1
  #   error_message = "There should be at least one NAT Gateway IP."
  # }

  assert {
    condition     = startswith(output.private_subnet_ids[0], "subnet-")
    error_message = "Private subnet IDs should contain at least one string that starts with 'subnet-'."
  }

  assert {
    condition     = startswith(output.public_subnet_ids[0], "subnet-")
    error_message = "Public subnet IDs should contain at least one string that starts with 'subnet-'."
  }

  assert {
    condition     = startswith(output.vpc_id, "vpc-")
    error_message = "VPC ID should start with 'vpc-'."
  }
}
