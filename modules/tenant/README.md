# Tenant Module 

Creates a tenant within an infrastructure. You can set some settings too. Try one of the variants to use different providers integrated into it. This module can be viewed as a box for creating any resource that would happen on a once per tenant basis.

## Variants  

- [AWS and Github Tenant](../tenant-gh-aws/) - Integrates Github Action Environments and an AWS Policy on a per tenant basis. 

## References

- [Duplocloud Docs for Tenants](https://docs.duplocloud.com/docs/welcome-to-duplocloud/application-focused-interface-duplocloud-architecture/duplocloud-common-components/tenant)
- [Duploctl CLI Command](https://cli.duplocloud.com/Tenant/)
- [Duplocloud Terraform Provider Tenant Resource](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/resources/tenant)



## Switching tenant module type

For example, If your tenant module is using regular `tenant` source, add the following import/move blocks while switching to `tenant-gh` OR you can do the other way around as well

```
source = duplocloud/components/duplocloud//modules/tenant  >>>  source  = "duplocloud/components/duplocloud//modules/tenant-gh"

# NOTE: See examples folder for tenant-type
```

```
moved {
  from = module.tenant.duplocloud_tenant.this
  to   = module.tenant.module.tenant.duplocloud_tenant.this
}

moved {
  from = module.tenant.duplocloud_tenant_config.this
  to   = module.tenant.module.tenant.duplocloud_tenant_config.this

}


# NOTE: these blocks can be removed after applied for all needed tenants 
```





