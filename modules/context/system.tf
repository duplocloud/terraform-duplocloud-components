# tflint-ignore: terraform_required_providers
data "http" "duplo_system" {
  url    = "${local.host}/v3/features/system"
  method = "GET"
  # Optional request headers
  request_headers = {
    Accept        = "application/json"
    Authorization = "Bearer ${local.token}"
  }
}

data "duplocloud_tenant" "this" {
  count = var.tenant != null ? 1 : 0
  name  = var.tenant
}

# only admin level can get the infra
data "duplocloud_infrastructure" "this" {
  count      = local.infra_name != null && var.admin ? 1 : 0
  infra_name = local.infra_name
}

data "duplocloud_infrastructure" "default" {
  count = (
    local.infra_name != "default" &&
    var.admin &&
    contains(["gcp", "azure"], local.cloud)
  ) ? 1 : 0
  infra_name = "default"
}

# if non admin then get region from data only if aws
data "duplocloud_tenant_aws_region" "this" {
  count = (
    local.cloud == "aws" &&
    var.tenant != null &&
    !var.admin
  ) ? 1 : 0
  tenant_id = local.tenant.id
}
