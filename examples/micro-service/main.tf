terraform {
  required_version = ">= 1.4.4"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.9.40"
    }
  }
  # backend "s3" {
  #   workspace_key_prefix = "duplocloud/components"
  #   key                  = "micro-service"
  #   encrypt              = true
  # }
}
provider "duplocloud" {}

variable "tenant" {
  description = "The tenant to deploy the service to."
  default     = "tf-tests"
  type        = string
}

module "some_service" {
  source = "../../modules/micro-service"
  tenant = var.tenant
  name   = "myapp"
  image = {
    uri = "nginx:latest"
  }
  port = 80
  lb = {
    enabled     = true
    certificate = "demo-cert"
    class       = "alb"
  }
  scale = {
    replicas = 2
    min      = 1
    max      = 5
    metrics = [{
      type = "Resource"
      resource = {
        name = "cpu"
        target = {
          type               = "Utilization"
          averageUtilization = 50
        }
      }
    }]
  }
  configurations = [{
    data = {
      BAZ = "buzz"
    }
    }, {
    name        = "bubbles"
    class       = "aws-secret"
    csi         = false
    managed     = false
    enabled     = false
    description = "This would build an aws secret with a k8s secret using a the csi driver. This then is mounted as a colume and envFrom"
    data = {
      BUBBLES = "are cool"
    }
    }, {
    type        = "files"
    class       = "secret"
    description = "This should not show up in envFrom because this configuration is for a set of files. It should show up in the volumes though."
    data = {
      "hello.txt" = "hello world"
    }
    }, {
    enabled     = false
    name        = "disabled"
    class       = "aws-ssm"
    csi         = false
    managed     = true
    type        = "environment"
    description = "This should be disabled so it should not be in the envfrom"
    data = {
      "HELLO" = "world"
    }
  }]
  jobs = [{
    enabled = true
    command = ["echo"]
    args    = ["before update"]
  }]
}

output "service" {
  value       = module.some_service
  description = "The service object."
}
