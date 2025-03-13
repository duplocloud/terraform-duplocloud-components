locals {
  system         = jsondecode(data.http.duplo_system.response_body)
  infra          = var.tenant != null && var.admin ? data.duplocloud_infrastructure.this[0] : null
  infra_name     = var.infra != null ? var.infra : local.tenant != null ? local.tenant.plan_id : null
  tenant         = var.tenant != null ? data.duplocloud_tenant.this[0] : null
  host           = data.external.duplo_creds.result.host
  token          = sensitive(data.external.duplo_creds.result.token)
  account_id     = local.system.DefaultAwsAccount
  default_region = local.system.DefaultAwsRegion
  region = coalesce(
    local.infra != null ? local.infra.region : null,
    var.tenant != null && !var.admin ? data.duplocloud_tenant_aws_region.this[0].aws_region : null,
    local.default_region
  ) # find the region from either the infra, the tenant, or default region
  tfstate_bucket = "duplo-tfstate-${local.account_id}"
  cloud = [
    for cloud, enabled in {
      aws   = local.system.IsAwsCloudEnabled
      azure = local.system.IsAzureCloudEnabled
      gcp   = local.system.IsGoogleCloudEnabled
    } : cloud
    if enabled
  ][0]
  creds = sensitive({
    aws   = var.jit.aws ? var.admin ? data.duplocloud_admin_aws_credentials.this[0] : data.duplocloud_tenant_aws_credentials.this[0] : null
    k8s   = var.jit.k8s ? var.admin ? data.duplocloud_eks_credentials.this[0] : data.duplocloud_tenant_eks_credentials.this[0] : null
    gcp   = null
    azure = null
  })
  workspaces = {
    for key, workspace in coalesce(var.workspaces, {}) : key => {
      name   = coalesce(workspace.name, terraform.workspace)
      prefix = coalesce(workspace.prefix, key)
      key    = coalesce(workspace.key, key)
    }
  }
}


