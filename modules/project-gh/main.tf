locals {
  repo = one(
    var.mode == "data" ? data.github_repository.this : github_repository.this
  )
  custom_properties = one(data.github_repository_custom_properties.this)
  props = local.custom_properties == null ? {} : {
    for p in local.custom_properties.property : p.property_name => tolist(p.property_value)
  }
  prop_keys = keys(local.props)
  condition = {
    service = {
      has_image = ["true"]
      class     = ["service"]
    }
  }
}

##
# Retrieves the top level files from the repo. 
# This enables us to check if files exist before operating on them. 
# Normally TF has issues with this because it doesn't know what to do when a resource already exists. 
# With this we can even make changes to files if needed. 
##
data "github_rest_api" "root_files" {
  endpoint = "repos/${var.owner}/${var.name}/contents"
}
