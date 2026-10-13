# module "configs" {
#   for_each = local.compose.configs
#   source = "../../modules/config"
#   tenant = var.tenant
#   name   = each.key
#   config = {
#     data = each.value.data
#   }
# }
