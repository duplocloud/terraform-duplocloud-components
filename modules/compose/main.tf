locals {
  docker_compose = yamldecode(templatefile(var.file, var.args))
  compose = {
    for component_type in ["services", "configs", "secrets"] : component_type => {
      for name, service in {
        for name, service in local.docker_compose[component_type] : name => service
        if contains(keys(service), "labels")
      } : name => service
      if contains(keys(service.labels), "duplo.class")
    }
  }
  services = {
    for name, service in local.compose.services : name => merge({
      command    = []
      entrypoint = []
      ports      = []
      }, service, {
      labels = merge({
        "duplo.class"      = "service"
        "duplo.lb.enabled" = "false"
      }, service.labels)
    })
  }
  secrets = {
    # values are the result of grouping from secret...
    # this groups all the secrets named the same together and combines the environment keys
    for name, values in {
      for name, secret in local.compose.secrets :
      lookup(secret, "name", name) => secret...
      } : name => {
      name = name
      labels = merge([
        for val in values : val.labels
      ]...)
      # each key in data is one of the environment keys and the refernces one of the args
      data = {
        for secret_key in values : 
        secret_key.environment => lookup(
          var.args, secret_key.environment, null
        )
        if contains(keys(secret_key), "environment")
      }
    }
  }
}
