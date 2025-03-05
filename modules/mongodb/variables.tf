variable "mongo_project_id" {
  description = "The ID of the MongoDB project"
  type        = string

}
variable "mongo_db_major_version" {
  description = "value of the major version of the MongoDB server"
  type        = string
}

variable "cluster_name" {
  description = "The name of the MongoDB cluster"
  type        = string

}

variable "cluster_type" {
  description = "The type of the MongoDB cluster"
  type        = string
  default     = "REPLICASET"

}

variable "environment" {
  description = "value of the environment"
  type        = string
}

variable "region_configs" {
  description = "value of the region_configs"
  type = object({
    electable_specs = object({
      instance_size = string
      node_count    = number
      disk_size_gb  = number
    })
    provider_name = string
    priority      = number
    region_name   = string
  })
}

variable "mongo_user_details" {
  description = "value of the mongo_user_details"
  type = object({
    username = string
    roles = object({
      database_name = string
      role_name     = string
    })
    auth_database_name = string
  })
}

variable "mongodb_atlas_public_key" {
  description = "The public key for the MongoDB Atlas provider"
  type        = string

}

variable "mongodb_atlas_private_key" {
  description = "The private key for the MongoDB Atlas provider"
  type        = string

}
