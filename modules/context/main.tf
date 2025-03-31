locals {
  system         = jsondecode(data.http.duplo_system.response_body)
  infra_name     = var.infra != null ? var.infra : local.tenant != null ? local.tenant.plan_id : null
  tenant         = var.tenant != null ? data.duplocloud_tenant.this[0] : null
  host           = data.external.duplo_creds.result.host
  token          = sensitive(data.external.duplo_creds.result.token)
  tfstate_bucket = "duplo-tfstate-${local.account_id}"


  ##
  # Discover the cloud we are on and try and get the id for this duplo isntance
  # This is helpful in determining how we will find certain details later on when clouds differn in ways. 
  ## 
  cloud = one([
    for cloud, enabled in {
      aws   = local.system.IsAwsCloudEnabled
      azure = local.system.IsAzureCloudEnabled
      gcp   = local.system.IsGoogleCloudEnabled
    } : cloud
    if enabled
  ])
  account_id = coalesce(
    local.cloud == "aws" ? local.system.DefaultAwsAccount : null,
    local.default_infra != null ? local.default_infra.account_id : null,
    local.infra != null ? local.infra.account_id : null,
    "na"
  )

  ## 
  # Get some infra info. 
  # Sometimes we need the default infrastructure. Like if the portal context
  # is gcp we can't just get the default region. We need to go get the default region 
  # from the default infrastructure. If the infra happens to be the default one then 
  # just use infra as the default so we don't make two calls. 
  ## 
  infra = (
    (var.tenant != null || var.infra != null) && var.admin
  ) ? data.duplocloud_infrastructure.this[0] : null
  default_infra = local.infra_name == "default" ? local.infra : one(data.duplocloud_infrastructure.default)

  ##
  # Get some information about the region and the default one
  # find the region from either the infra, the tenant, or default region
  ##
  region = coalesce(
    local.infra != null ? local.infra.region : null,
    (
      var.tenant != null &&
      !var.admin &&
      local.cloud == "aws"
    ) ? data.duplocloud_tenant_aws_region.this[0].aws_region : null,
    local.default_region
  )
  default_region = coalesce(
    local.cloud == "aws" ? local.system.DefaultAwsRegion : null,
    local.default_infra != null ? local.default_infra.region : null,
    "na"
  )

  creds = sensitive({
    aws   = var.jit.aws ? var.admin ? data.duplocloud_admin_aws_credentials.this[0] : data.duplocloud_tenant_aws_credentials.this[0] : null
    k8s   = var.jit.k8s ? var.admin ? data.duplocloud_eks_credentials.this[0] : data.duplocloud_tenant_eks_credentials.this[0] : null
    gcp   = null
    azure = null
  })
  workspaces = {
    for key, workspace in coalesce(var.workspaces, {}) : key => {
      name    = coalesce(workspace.name, terraform.workspace)
      prefix  = coalesce(workspace.prefix, key)
      key     = coalesce(workspace.key, key)
      nameRef = workspace.nameRef
    }
  }
}

check "unable-to-determine-account-or-region" {
  assert {
    condition = !(
      local.default_region == "na" ||
      local.account_id == "na"
    )
    error_message = <<EOT
Unable to determine the default region or the account id. You will have to manually provide these.
Maybe try setting the variable "admin" to true. This would check on the default infra which will have this information. 
EOT
  }
}
