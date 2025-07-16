# Duplo Configuration Module 

Builds a configuration a number of ways for an application. 

## Classes  

Each class is a different way to build a configuration. The following sections details the different classes. To set the class, use the `class` variable as an input. The default is `configmap`. 

Options for `class` are:  
- `configmap`  
- `secret`
- `aws-secret`
- `aws-ssm`

## CSI Support  

If your cluster has the aws csi driver for secrets enabled, then this can be true. When true you can use `aws-secret` or `aws-ssm` as the class.

## Remapping Keys 

The keys in the data input may be changed by this configuration for the application. 

When the configuration is type `environment` then the remapping will cause the configuration to output env variables using kubernetes valueFrom syntax to map each value in the data to new environment variable names. So instead of getting `envFrom` output, you get a list of `env` variables which map each env var name to a keys name in the source ConfigMap or Secret.  

## Managed versus Unmanaged 

The `managed` key is a boolean value determining wether or not terraform should manage the actual values in the data/value or it should ignore those values. If true and terraform performs and apply, then the values will be set to what the terraform code dictates those values to be. When false, terraform will only create the resource with default values from the data/value variables. any successive update would ignore the data/value within the tf. Unmanaged data is useful to simply default the keys so a developer may add the actual values themselves and the terraform won't overwrite them. 

## External Configuration  

When the underlying resource for a configuration has already been created, you may set the `external` variable to true. When true, the `data` nor `value` variables will be used. 

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
