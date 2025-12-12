# Duplocloud Terraform Modules  

[![Module Tests](https://github.com/duplocloud/terraform-duplocloud-components/actions/workflows/test.yml/badge.svg)](https://github.com/duplocloud/terraform-duplocloud-components/actions/workflows/test.yml) [![TF Registry](https://img.shields.io/badge/TF-Registry-%23844FBA?style=flat-square&logo=terraform)](https://registry.terraform.io/modules/duplocloud/components/duplocloud/latest)

A collection of common cloud patterns built on top of the official Duplocloud Terraform provider. Use these to greatly speed up your TF journey. 

## Testing  

To run the unit tests when in a module directory:  
```sh
tf test -filter=tests/unit.tftest.hcl
```

## General Usage  

To use a module in your project, add the following to your `some.tf` file:  
```hcl
module "components" {
  source  = "duplocloud/components/duplocloud"
  version = "0.0.22"
}
```

## Terraform Modules Index

| Module | Description |
|--------|-------------|
| [api-gateway](modules/api-gateway/README.md) | |
| [compose](modules/compose/README.md) | |
| [configuration](modules/configuration/README.md) | Builds configuration for an application in several ways (configmap, secret, aws-secret, aws-ssm). |
| [context](modules/context/README.md) | Provides useful outputs and context variables to speed up DuploCloud development. |
| [eks-nodes](modules/eks-nodes/README.md) | Creates DuploCloud EKS hosts for a tenant with HA setup and optional ASG refresh. |
| [env-file](modules/env-file/README.md) | |
| [gamelift-build](modules/gamelift-build/README.md) | Creates a Gamelift build from an S3 artifact and a fleet with the build. |
| [infrastructure](modules/infrastructure/README.md) | |
| [lambda](modules/lambda/README.md) | |
| [loadbalancer](modules/loadbalancer/README.md) | |
| [micro-service](modules/micro-service/README.md) | Creates a Duplo service with a single service and optional load balancer. |
| [mongodb](modules/mongodb/README.md) | |
| [retool-bastion](modules/retool-bastion/README.md) | Sets up a bastion server for Retool to access private resources like databases. |
| [tenant](modules/tenant/README.md) | |
| [tenant-data-aws](modules/tenant-data-aws/README.md) | Aggregate data that's available through the DuploCloud tenant. |
| [tenant-gh](modules/tenant-gh/README.md) | |
| [tenant-gh-aws](modules/tenant-gh-aws/README.md) | |
| [tenant-role-extension](modules/tenant-role-extension/README.md) | |
| [website-gcp](modules/website-gcp/README.md) | |
