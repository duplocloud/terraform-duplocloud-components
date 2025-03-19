locals {
  name = duplocloud_infrastructure.this.infra_name
  clouds = {
    aws    = 0
    oracle = 1
    azure  = 2
    google = 3
  }
}


