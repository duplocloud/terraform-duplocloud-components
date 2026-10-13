module "services" {
  for_each = {
    for name, service in local.services : name => service
    if service.labels["duplo.class"] == "service"
  }
  source = "../../modules/micro-service"
  tenant = var.tenant
  name   = each.key
  image = {
    uri = each.value.image
  }
  # if there is a port use regex to get the right side of the colon of the poirt
  port = length(each.value.ports) > 0 ? split(":", each.value.ports[0])[0] : 80
  lb = {
    enabled = (each.value.labels["duplo.lb.enabled"] == "true")
  }
}
