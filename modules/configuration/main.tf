locals {
  id        = var.name != null ? var.name : var.type == "environment" ? "env" : "configs"
  name      = nonsensitive(var.prefix != null ? "${var.prefix}-${local.id}" : local.id)
  realName  = nonsensitive(local.resource != null ? local.resource[local.schema.name_key] : local.name)
  data      = var.data != null ? var.data : {}
  value     = var.value != null ? var.value : jsonencode(local.data)
  keys      = keys(local.data)
  schema    = local.definitions[var.class]
  config    = local.configurations[var.class]
  resource  = length(local.config) > 0 ? local.config[0] : null
  volume    = [for k, v in local.volumes : v if v != null]
  envFrom   = [for k, v in local.envFromMap : v if v != null]
  mountPath = var.mountPath != null ? var.mountPath : "/mnt/${local.id}"
  csi       = contains(["aws-secret", "aws-ssm"], var.class) ? var.csi : false
  is_ssm    = startswith(var.class, "aws-ssm")
  annotations = {
    "kubernetes.io/description" = var.description
  }
  envFromMap = {
    configmap = var.enabled && var.type == "environment" && var.class == "configmap" ? {
      configMapRef = {
        name = local.name
      }
    } : null
    secret = var.enabled && var.type == "environment" && (var.class == "secret" || local.csi) ? {
      secretRef = {
        name = local.name
      }
    } : null
  }
  volumes = {
    csi = var.enabled && local.csi ? {
      name = local.id
      csi = {
        driver   = "secrets-store.csi.k8s.io"
        readOnly = true
        volumeAttributes = {
          secretProviderClass = local.name
        }
      }
    } : null
    configmap = var.enabled && var.class == "configmap" && var.type == "files" ? {
      name = local.id
      configMap = {
        name = local.realName
      }
    } : null
    secret = var.enabled && var.class == "secret" && var.type == "files" ? {
      name = local.id
      secret = {
        secretName = local.realName
      }
    } : null
  }
  definitions = {
    secret = {
      name_key = "secret_name"
    }
    configmap = {
      name_key = "name"
    }
    aws-secret = {
      name_key = "name"
      csiType  = "secretsmanager"
    }
    aws-ssm = {
      name_key = "name"
      type     = "String"
      csiType  = "ssmparameter"
    }
    aws-ssm-secure = {
      name_key = "name"
      type     = "SecureString"
      csiType  = "ssmparameter"
    }
    aws-ssm-list = {
      name_key = "name"
      type     = "StringList"
      csiType  = "ssmparameter"
    }
  }
  configurations = {
    secret         = var.class == "secret" ? var.managed ? duplocloud_k8_secret.managed : duplocloud_k8_secret.unmanaged : null
    configmap      = var.class == "configmap" ? var.managed ? duplocloud_k8_config_map.managed : duplocloud_k8_config_map.unmanaged : null
    aws-secret     = var.class == "aws-secret" ? var.managed ? duplocloud_tenant_secret.managed : duplocloud_tenant_secret.unmanaged : null
    aws-ssm        = var.class == "aws-ssm" ? var.managed ? duplocloud_aws_ssm_parameter.managed : duplocloud_aws_ssm_parameter.unmanaged : null
    aws-ssm-secure = var.class == "aws-ssm-secure" ? var.managed ? duplocloud_aws_ssm_parameter.managed : duplocloud_aws_ssm_parameter.unmanaged : null
    aws-ssm-list   = var.class == "aws-ssm-list" ? var.managed ? duplocloud_aws_ssm_parameter.managed : duplocloud_aws_ssm_parameter.unmanaged : null
  }
}
