data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

data "duplocloud_infrastructure" "this" {
  tenant_id = data.duplocloud_tenant.this.id
}

data "duplocloud_plan" "this" {
  plan_id = data.duplocloud_tenant.this.plan_id
}

data "duplocloud_plan_settings" "this" {
  plan_id = data.duplocloud_tenant.this.plan_id
}

locals {
  dns_domain = trim(one(data.duplocloud_plan_settings.this.dns_setting).external_dns_suffix, ".")
}

# Plans can have many certificates. Most plans create a default one automatically.
data "duplocloud_plan_certificate" "default" {
  count = var.default_certificate_enabled ? 1 : 0

  name    = "duplo-default/.${local.dns_domain}"
  plan_id = data.duplocloud_tenant.this.plan_id
}

data "duplocloud_aws_account" "this" {
  tenant_id = data.duplocloud_tenant.this.id
}

data "duplocloud_tenant_aws_region" "this" {
  tenant_id = data.duplocloud_tenant.this.id
}

data "aws_iam_role" "this" {
  name = "duploservices-${var.tenant_name}"
}

data "aws_security_group" "this" {
  name = "duploservices-${var.tenant_name}"
}
