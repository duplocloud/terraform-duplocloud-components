terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 6.26.0"
      configuration_aliases = [aws.vpn_region]
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.11.27"
    }
  }
}

variable "stack_name" {
  description = "Name of the CloudFormation stack managing the VPN."
  default     = "duplo-openvpn-v1"
  type        = string
}

locals {
  enabled    = contains(data.duplocloud_system_features.this.enabled_flags, "EnableVPN")
  private_ip = local.enabled ? one(data.aws_cloudformation_stack.openvpn).outputs["PrivateIp"] : null
  public_ip  = local.enabled ? one(data.aws_cloudformation_stack.openvpn).outputs["PublicIp"] : null
}

data "duplocloud_system_features" "this" {}

data "aws_cloudformation_stack" "openvpn" {
  count = local.enabled ? 1 : 0

  provider = aws.vpn_region

  name = var.stack_name
}

output "enabled" {
  description = "Whether or not the VPN is enabled for this portal."
  value       = local.enabled
}

output "private_ip" {
  description = "Private IP address of the VPN (if it exists)."
  value       = local.private_ip
}

output "public_ip" {
  description = "Public IP address of the VPN (if it exists)."
  value       = local.public_ip
}
