locals {
  name = duplocloud_infrastructure.this.infra_name
  clouds = {
    aws    = 0
    oracle = 1
    azure  = 2
    google = 3
  }
  address_prefix = var.address_prefix != null ? var.address_prefix : data.external.cidrinc[0].result.next
}

data "duplocloud_infrastructures" "all" {
  count = var.address_prefix == null ? 1 : 0
}

# tflint-ignore: terraform_required_providers
data "external" "cidrinc" {
  count = var.address_prefix == null ? 1 : 0
  program = concat([
    "${path.module}/cidrinc.sh"
    ], [
    for infra in data.duplocloud_infrastructures.all[0].data : infra.address_prefix
  ])
}
