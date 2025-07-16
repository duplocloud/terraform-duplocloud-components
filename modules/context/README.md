# Duplocloud Context  

Brings together a bunch of data you will be wanting to get enough context to do whatever it is you are doing. The outputs contain a number of useful variables you would end up discovering yourself with a bunch of data blocks in terraform. This greatly speeds up development with Duplocloud simply because you can get the data you need without having to write a bunch of data blocks.

## Usage

From source:  
```terraform
module "ctx" {
  source = "git::https://github.com/duplocloud/terraform-duplocloud-components.git//modules/context?ref=main"
}
```

## JIT  

This module can get JIT credentials for and admin or a non admin. The token itself is actually what gives you admin credentials, the `admin` variable here like the `duploctl --admin` flag, only says you actually want to be admin. If you are not an actual admin setting the `admin` variable to true will only cause authentication errors. Just like the rest of the variables, each input key has a matching output key. 

```terraform 
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  admin  = true
  jit = {
    aws = true
    k8s = true
  }
}
```

The following resources are created by this module to support JIT and the values are outputted for use in your own module.  
- [duplocloud_admin_aws_credentials](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/admin_aws_credentials)
- [duplocloud_tenant_aws_credentials](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant_aws_credentials)
- [duplocloud_eks_credentials](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/eks_credentials)
- [duplocloud_tenant_eks_credentials](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant_eks_credentials)

So if you were to set the `jit.aws` to true, you can access all of the outputs from the data block `[duplocloud_admin_aws_credentials](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/admin_aws_credentials)` like this in a provider block:  
```terraform
provider "aws" {
  region     = local.infra.region
  access_key = module.ctx.jit.aws.access_key_id
  secret_key = module.ctx.jit.aws.secret_access_key
  token      = module.ctx.jit.aws.session_token
}
```

## Tenant and Infrastructure Context  

Simply giving a tenant name in the `tenant` variable will auto load a data reference to the tenant into the output. If you are an admin, and auto ref to the infra will be made as well.  
```terraform 
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  tenant = "dev01"
}
```
Now you would be able to access all of the values on a `[duplocloud_tenant](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant)` from the `tenant` key on the ouptputs of the module, for example to get the ID you would do this: `module.ctx.tenant.id`, or the name with `module.ctx.tenant.name`.

If you are an admin you may enter a name in the `infra` variable to auto load the infrastructure which will not auto load the tenant into the output. 
```terraform 
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  infra  = "nonprod01"
  admin  = true
}
```

If the `tenant` is given instead of the `infra` then the tenant and infrastructure will auto load and be shown in the output. 
```terraform 
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  tenant = "dev01"
  admin  = true
}
```

## Workspace References  

As there is a default state location for duplo terraform workspaces, this along with other context can make references to other workspaces very easy. The variable `workspaces` is a map of reference objects to other workspaces in the states storage medium wether that is AWS S3, GCP Buckets, or Azure buckets. The outputs from these workspaces are applied to the `workspaces` output of this module. Each key for a workspace is the reference variable for the workpsace on the output, ie the name you reference to get it's outputs. Each reference object has the following keys: `name`, `prefix`, and `key`. The name is the name of the workspace aka instance of the module. The `key` is the name of the state file in the medium and will default to the key used within the input map. The `prefix` is only relevant for aws and defaults to the `key` as well, ie the state file for a tenant in the bucket is `tenant/tenant`. 

```terraform
locals {
  # get a value from the output of a workspace
  message = module.ctx.workspaces.configuration.message
}
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  workspaces = {
    # key and prefix will be tenant and name will be tf workspace
    tenant = {} 
    # key will be configurations and name is the tf workspace because it was left out
    configuration = {
      prefix = "tenant"
    }
    # here is one where all are spelled out
    devops = {
      name   = "myportal"
      prefix = "portal"
      # key    = "devops" # this defaults to they key which is devops in this case. 
    }
  }
}
```

The value of the object for each key on the outputs will be the outputs from another workspace originating from a [terraform_remote_state](https://developer.hashicorp.com/terraform/language/state/remote-state-data) data block. In the example above, you can access the outputs from the tenant workspace like this: `module.ctx.workspaces.tenant.id`, or the message from the configuration workspace like this: `module.ctx.workspaces.configuration.message`.

## Terraform State Bucket Name 

Normally every portal comes with it's own bucket for the terraform state. The name is easily guessable using the account id. Sometimes, the bucket is not the standard bucket and must be explicitly set using the `StateBucket` variable in the `AppConfig` for the portal. In your `portal` modules you can add the following to set the bucket name: 
```terraform
resource "duplocloud_admin_system_setting" "tf_bucket" {
  key   = "StateBucket"
  value = "my-tf-state-bucket-name"
  type  = "AppConfig"
}
```
This value corresponds with the `DUPLO_TF_BUCKET` environment variable and these two values should be the same. When this value is set, the module will use this to make references to other modules when using the `workspaces` variable. 
