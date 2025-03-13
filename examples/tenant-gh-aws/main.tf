terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "0.11.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
  backend "s3" {
    workspace_key_prefix = "duplocloud/components"
    key                  = "tenant-gh-aws"
    encrypt              = true
  }
}
provider "duplocloud" {}

provider "github" {
  owner = "duplocloud"
  app_auth {}
}

provider "aws" {
  region     = module.ctx.region
  access_key = module.ctx.creds.aws.access_key_id
  secret_key = module.ctx.creds.aws.secret_access_key
  token      = module.ctx.creds.aws.session_token
}

variable "infra_name" {
  description = "The name of the infrastructure to place the tenant in."
  type        = string
  default     = "oteltest"
}

module "ctx" {
  source = "../../modules/context"
  infra  = var.infra_name
  admin  = true
  jit = {
    aws = true
  }
}

module "tenant" {
  source     = "../../modules/tenant-gh-aws"
  infra_name = var.infra_name
  name       = terraform.workspace
  repos = [
    "terraform-duplocloud-components"
  ]
  settings = {
    enable_service_on_any_host = "true"
  }
  configurations = [{
    description = "A shared configuration for all services in this tenant."
    data = {
      SHARED = "something"
    }
  }]
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "BedrockAccess",
        "Effect" : "Allow",
        "Action" : [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ],
        "Resource" : [
          "arn:aws:bedrock:*:1234567890:provisioned-model/*",
          "arn:aws:bedrock:*:1234567890:imported-model/*",
          "arn:aws:bedrock:*::foundation-model/*",
          "arn:aws:bedrock:*:1234567890:inference-profile/*",
          "arn:aws:bedrock:*:1234567890:application-inference-profile/*",
          "arn:aws:bedrock:*:1234567890:async-invoke/*",
          "arn:aws:bedrock:*:1234567890:default-prompt-router/*",
          "arn:aws:bedrock:*:1234567890:marketplace/model-endpoint/all-access"
        ]
      }
    ]
  })
}
