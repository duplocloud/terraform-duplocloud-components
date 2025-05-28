output "host" {
  description = <<EOT
The DuploCloud host URL for the portal.
EOT
  value       = local.host
}

output "account_id" {
  description = <<EOT
When on aws this is the Account ID. 
On GCP this is the Project ID. 
When on Azure this is the Subscription ID.
EOT
  value       = local.account_id
}

output "cloud" {
  description = <<EOT
The cloud provider that this context is for. 
This is determined based on making a system call to the portal to discover basic information about the portal like where it is installed. 
EOT
  value       = local.cloud
}

output "state_bucket" {
  description = <<EOT
The name of the pre-existing bucket that is used to store the Terraform state files.
This bucket is created alongside the duplo portal and can be easily guessed in TF. 
This output is so you don't have to manually build that bucket name yourself if it is needed. 
EOT
  value       = local.tfstate_bucket
}

output "default_region" {
  description = <<EOT
This is the region the portal is installed into. 
EOT
  value       = local.default_region
}

output "region" {
  description = <<EOT
This is the region of the current context which is determined either by selecting a tenant or infra. 
If neither a tenant or infra is selected then this is simply the default region. 
EOT
  value       = local.region
}

output "system" {
  description = <<EOT
The portal level information that describes our system. As long as you are authenticated with the portal, this will always be available.
Here is where we can find default information like which cloud we are on or what the default region is. 

Useful note, this is the cli command to get this same information: `duploctl system info`.
EOT
  value       = local.system
}

output "infra" {
  description = <<EOT
This is the output from a [duplocloud_infrastructure](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/infrastructure) data source. If the `admin` variable is true and a value is set for `tenant`, then this will always be outputted. If one is admin, then a name can be provided on the `infra` input variable so this output becomes available.
EOT
  value       = local.infra
}

output "default_infra" {
  description = <<EOT
The Default infrastructure if one was looked up. This outputs the a [duplocloud_infrastructure](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/infrastructure) data source for the tenant named `default`. This comes with some juicy information that may or may not already be available on the system output. 
EOT
  value       = local.default_infra
}

output "tenant" {
  description = <<EOT
The entire tenant object based on the name given in the `tenant` input variable. 

See tenant data object for more details about the attributes available.
https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs/data-sources/tenant
EOT
  value       = local.tenant
}

output "workspaces" {
  description = <<EOT
The map of references using the ouputs from each workspaces remote state.
Each value in the map will be the outputs from the referenced workspace. 
Each value is the outputs from this builtin terrafrom resource: https://developer.hashicorp.com/terraform/language/state/remote-state-data
EOT
  value = merge({
    for key, ref in data.terraform_remote_state.refs : key => ref.outputs
    }, {
    for key, ref in data.terraform_remote_state.namerefs : key => ref.outputs
  })
}

output "jit" {
  description = <<EOT
The map of enabled JIT login credentials for each provider.
Each key within the JIT input which is set to true will have actual credentials outputed under the same key in this output. 
This value is ephemeral so the credentials will not be saved in state ever. 

For example: 
If aws is true under JIT then there will be an out put like `module.ctx.jit.aws.access_key` which will contain the credentials for the AWS provider.
```hcl
module "ctx" {
  source  = "duplocloud/components/duplocloud//modules/context"
  version = "0.0.39"
  admin   = true
  jit = {
    aws = true
  }
```
EOT
  sensitive   = true
  ephemeral   = true
  value = {
    for key, cred in local.creds : key => cred
    if cred != null
  }
}
