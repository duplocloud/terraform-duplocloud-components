# MongoDB Terraform Module

This Terraform module provisions a MongoDB cluster using MongoDB Atlas. It supports advanced cluster configurations, user management, and region-specific settings.

## Usage

```hcl
module "mongodb" {
  source = "path/to/this/module"

  mongo_project_id       = "your_project_id"
  mongo_db_major_version = "5.0"
  cluster_name           = "example-cluster"
  cluster_type           = "REPLICASET"
  environment            = "production"
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
    username = "admin"
    roles = {
      database_name = "admin"
      role_name     = "readWrite"
    }
    auth_database_name = "admin"
  }
}
```

## Inputs

### Inputs

- **`mongo_project_id`**: _(Required)_ The ID of the MongoDB project. Type: `string`.

- **`mongo_db_major_version`**: _(Required)_ Major version of the MongoDB server. Type: `string`.

- **`cluster_name`**: _(Required)_ The name of the MongoDB cluster. Type: `string`.

- **`cluster_type`**: _(Optional)_ The type of the MongoDB cluster. Defaults to `"REPLICASET"`. Type: `string`.

- **`environment`**: _(Required)_ The environment value. Type: `string`.

- **`region_configs`**: _(Required)_ Region configurations.

  ```hcl
  {
    electable_specs = {
      instance_size = string
      node_count    = number
      disk_size_gb  = number
    }
    provider_name = string
    priority      = number
    region_name   = string
  }
  ```

- **`mongo_user_details`**: _(Required)_ MongoDB user details.
  ```hcl
  {
    username = string
    roles = {
      database_name = string
      role_name     = string
    }
    auth_database_name = string
  }
  ```

## Outputs

This module does not define any outputs.

## Resources

- `mongodbatlas_advanced_cluster.this`: Provisions an advanced MongoDB cluster.
- `random_password.mongodb_password`: Generates a random password for the MongoDB user.
- `mongodbatlas_database_user.user`: Creates a MongoDB database user.

## Example

Refer to the [examples](../../examples/mongodb/) directory for a complete example of how to use this module.
