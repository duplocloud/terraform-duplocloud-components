terraform {
  required_version = ">= 1.9.0"

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

