# Specify the required Terraform version for compatibility
terraform {
  required_version = "~> 1.10.5"

  # Specify required providers and their versions
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas",
      version = "1.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }

  }
}


# Use the secrets in the MongoDB Atlas provider


provider "random" {}

module "mongo_atlas" {
  source                 = "../../modules/mongodb"
  cluster_name           = "my-mongodb-cluster"
  cluster_type           = "REPLICASET"
  environment            = "dev"
  mongo_db_major_version = 7
  mongo_project_id       = "my-project-id"
  region_configs = {
    electable_specs = {
      instance_size = "M10"
      node_count    = 3
      disk_size_gb  = 10
    }
    provider_name = "AWS"
    priority      = 7
    region_name   = "US_EAST_1"
  }
  mongo_user_details = {
    username = "myuser"
    roles = {
      database_name = "admin"
      role_name     = "readWrite"
    }
    auth_database_name = "admin"
  }

}
