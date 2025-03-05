resource "mongodbatlas_advanced_cluster" "this" {
  project_id             = var.mongo_project_id
  name                   = var.cluster_name
  cluster_type           = var.cluster_type
  mongo_db_major_version = var.mongo_db_major_version
  tags {
    key   = "environment"
    value = var.environment
  }
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = var.region_configs.electable_specs.instance_size
        node_count    = var.region_configs.electable_specs.node_count
        disk_size_gb  = var.region_configs.electable_specs.disk_size_gb
      }
      provider_name = var.region_configs.provider_name
      priority      = var.region_configs.priority
      region_name   = var.region_configs.region_name
    }
  }
}

resource "random_password" "mongodb_password" {
  length           = 16
  special          = false
  override_special = ""
}
resource "mongodbatlas_database_user" "user" {
  username   = var.mongo_user_details.username
  password   = random_password.mongodb_password.result
  project_id = var.mongo_project_id
  roles {
    database_name = var.mongo_user_details.roles.database_name
    role_name     = var.mongo_user_details.roles.role_name
  }
  auth_database_name = var.mongo_user_details.auth_database_name
}
