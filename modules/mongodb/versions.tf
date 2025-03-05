# Specify the required Terraform version for compatibility
terraform {
  required_version = "~> 1.11.0"

  # Specify required providers and their versions
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas",
      version = "1.24.0"
    }

  }
}


# Use the secrets in the MongoDB Atlas provider
provider "mongodbatlas" {
  public_key  = ""
  private_key = ""
}

provider "random" {}

