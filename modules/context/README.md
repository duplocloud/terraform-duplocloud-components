# Duplocloud Context  

Brings together a bunch of data you will be wanting to get enough context to do whatever it is you are doing.

## Usage

From source:  
```terraform
module "ctx" {
  source = "git::https://github.com/duplocloud/terraform-duplocloud-components.git//modules/context?ref=main"
}
```

## JIT  

This module can get JIT credentials for and admin or a non admin. The token itself is actually what gives you admin credentials, the `admin` variable here like the `duploctl --admin` flag, only says you actually want to be admin. If you are not an actual admin setting the `admin` variable to true will only cause authentication errors. 

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

## Tenant and Infrastructure Context  

Simply giving a tenant name in the `tenant` variable will auto load a data reference to the tenant into the output. If you are an admin, and auto ref to the infra will be made as well.  
```terraform 
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  tenant = "dev01"
}
```


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

As there is a default s3 location for duplo terraform workspaces, this along with other context can make references to other workspaces very easy. The variable `workspaces` is a map of reference objects to other workspaces in the s3 bucket. The outputs from these workspaces are applied to the `refs` output.  

```terraform
locals {
  # get a value from the output of a workspace
  message = module.ctx.refs.configuration.message
}
module "ctx" {
  source = "duplocloud/components/duplocloud//modules/context"
  workspaces = {
    # key and prefix will be tenant and name will be tf workspace
    tenant = {} 
    # key will be configurations and name is the tf workspace
    configuration = {
      prefix = "tenant"
    }
    # here is one where all are spelled out
    devops = {
      name   = "myportal"
      prefix = "portal"
      key    = "devops.tfstate"
    }
  }
}
```
