output "host" {
  value = local.host
}

output "account_id" {
  value = local.account_id
}

output "cloud" {
  value = local.cloud
}

output "state_bucket" {
  value = local.tfstate_bucket
}

output "default_region" {
  value = local.default_region
}

output "region" {
  value = local.region
}

output "system" {
  value = local.system
}

output "infra" {
  value = local.infra
}

output "default_infra" {
  description = "The Default infrastructure if one was looked up."
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
  description = "The map of references using the ouputs from each workspaces remote state."
  value = merge({
    for key, ref in data.terraform_remote_state.refs : key => ref.outputs
    }, {
    for key, ref in data.terraform_remote_state.namerefs : key => ref.outputs
  })
}

output "creds" {
  description = "The map of enabled JIT login credentials for each provider."
  sensitive   = true
  value = {
    for key, cred in local.creds : key => cred
    if cred != null
  }
}
