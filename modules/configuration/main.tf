locals {
  id               = var.name != null ? var.name : var.type == "environment" ? "env" : "configs"
  name             = nonsensitive(var.prefix != null ? "${var.prefix}-${local.id}" : local.id)
  realName         = nonsensitive(local.resource != null ? local.resource[local.schema.name_key] : local.name)
  data             = var.data != null ? var.data : {}
  value            = var.value != null ? var.value : jsonencode(local.data)
  keys             = keys(local.data)
  schema           = local.definitions[var.class]
  resource         = one(local.configurations[var.class])
  csi              = contains(["aws-secret", "aws-ssm"], var.class) ? var.csi : false
  is_ssm           = startswith(var.class, "aws-ssm")
  is_tenant_secret = contains(["aws-secret", "gcp-secret"], var.class)
  annotations = {
    "kubernetes.io/description" = var.description
  }

  ##
  # Envfrom Section 
  # When the type is environment, then envfrom might be enabled.
  # If a remap is given, then env is instead used. 
  # The envFrom var is grabbing the non null keys from the envFromMap.
  ## 
  envFrom        = [for k, v in local.envFromMap : v if v != null]
  envFromEnabled = var.enabled && var.type == "environment" && !local.is_remapped
  envFromMap = {
    configmap = local.envFromEnabled && var.class == "configmap" ? {
      configMapRef = {
        name = local.name
      }
    } : null
    secret = local.envFromEnabled && (var.class == "secret" || local.csi) ? {
      secretRef = {
        name = local.name
      }
    } : null
  }

  ##
  # Remap Section for Env
  # If there are remapped keys, then the environment is mounted as env instead of envFrom.
  # This means each key is an env var using valueFrom to a new key name. 
  # Each key in the remap is a key in the data and the value in the remap is the new key in the environment.
  # The unique list of keys from the data and remap which enables external secrets to only have the remapped keys or anything that wants a duplicate value with two names.
  ## 
  is_remapped = (
    var.enabled &&
    var.remap != null &&                         # only when it is given
    contains(["configmap", "secret"], var.class) # only k8s resources do this right now
  )
  remap = local.is_remapped ? merge(
    var.remap,
    { # these are the keys that are not remapped, but still need to be included in the env
      for k in setsubtract(local.keys, distinct(values(var.remap))) : k => k
    }
  ) : {}

  ## 
  # Environment Variables Section
  # Combines any environment variables that are needed for the configuration.
  ##
  env = concat(
    var.type == "environment" ? [
      for k, v in local.remap : {
        name = k
        valueFrom = {
          "${local.schema.envRef}" = {
            name = local.realName
            key  = v
          }
        }
      }
    ] : [],
    var.type == "reference" ? [
      {
        name  = "${upper(var.class)}_${local.id}"
        value = local.realName
      }
    ] : []
  )

  ## 
  # Volume Section
  ##
  volume    = [for k, v in local.volumes : v if v != null]
  mountPath = var.mountPath != null ? var.mountPath : "/mnt/${local.id}"
  volumeMounts = (
    var.enabled && (var.type == "files" || local.csi)
    ) ? local.is_remapped ? [
    # if remap is enabled then we will mount each file in the remap
    for k, v in local.remap : {
      name      = local.id
      mountPath = "${local.mountPath}/${k}" # this is the renamed file
      readOnly  = true
      subPath   = v # this is the original file name from the value of the remap
    }
    ] : [
    # if remap is not enabled then we will mount the original file names all into the mount directory
    {
      name      = local.id
      mountPath = local.mountPath
      readOnly  = true
      subPath   = null
    }
  ] : null
  volumes = {

    # add the csi volume if enabled
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

    # adds a configmap volume if type files and class is configmap
    configmap = var.enabled && var.class == "configmap" && var.type == "files" ? {
      name = local.id
      configMap = {
        name = local.realName
      }
    } : null

    # adds a secret volume if type files and class is secret
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
      cloud    = "k8s"
      envRef   = "secretKeyRef"
    }
    configmap = {
      name_key = "name"
      cloud    = "k8s"
      envRef   = "configMapKeyRef"
    }
    gcp-secret = {
      name_key = "name"
      csiType  = "secretsmanager"
      cloud    = "gcp"
    }
    aws-secret = {
      name_key = "name"
      csiType  = "secretsmanager"
      cloud    = "aws"
    }
    aws-ssm = {
      name_key = "name"
      type     = "String"
      csiType  = "ssmparameter"
      cloud    = "aws"
    }
    aws-ssm-secure = {
      name_key = "name"
      type     = "SecureString"
      csiType  = "ssmparameter"
      cloud    = "aws"
    }
    aws-ssm-list = {
      name_key = "name"
      type     = "StringList"
      csiType  = "ssmparameter"
      cloud    = "aws"
    }
  }
  configurations = {
    secret         = var.class == "secret" ? var.managed ? duplocloud_k8_secret.managed : duplocloud_k8_secret.unmanaged : null
    configmap      = var.class == "configmap" ? var.managed ? duplocloud_k8_config_map.managed : duplocloud_k8_config_map.unmanaged : null
    gcp-secret     = var.class == "gcp-secret" ? var.managed ? duplocloud_tenant_secret.managed : duplocloud_tenant_secret.unmanaged : null
    aws-secret     = var.class == "aws-secret" ? var.managed ? duplocloud_tenant_secret.managed : duplocloud_tenant_secret.unmanaged : null
    aws-ssm        = var.class == "aws-ssm" ? var.managed ? duplocloud_aws_ssm_parameter.managed : duplocloud_aws_ssm_parameter.unmanaged : null
    aws-ssm-secure = var.class == "aws-ssm-secure" ? var.managed ? duplocloud_aws_ssm_parameter.managed : duplocloud_aws_ssm_parameter.unmanaged : null
    aws-ssm-list   = var.class == "aws-ssm-list" ? var.managed ? duplocloud_aws_ssm_parameter.managed : duplocloud_aws_ssm_parameter.unmanaged : null
  }
}
