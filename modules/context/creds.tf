data "external" "duplo_creds" {
  program = [
    "bash", "-c",
    <<EOT
cat <<EOF
{
  "host": "$DUPLO_HOST",
  "token": "$DUPLO_TOKEN"
}
EOF
EOT
  ]
}

data "duplocloud_admin_aws_credentials" "this" {
  count = var.admin && var.jit.aws ? 1 : 0
}

data "duplocloud_tenant_aws_credentials" "this" {
  count     = var.tenant != null && !var.admin && var.jit.aws ? 1 : 0
  tenant_id = local.tenant.id
}

data "duplocloud_eks_credentials" "this" {
  count   = local.infra_name != null && var.admin && var.jit.k8s ? 1 : 0
  plan_id = local.infra_name
}

data "duplocloud_tenant_eks_credentials" "this" {
  count     = var.tenant != null && !var.admin && var.jit.k8s ? 1 : 0
  tenant_id = local.tenant.id
}
