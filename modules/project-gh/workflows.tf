# resource "github_repository_file" "image_workflow" {
#   count               = contains(local.active_workflows, "image") ? 1 : 0
#   repository          = var.name
#   branch              = local.repo.default_branch
#   commit_message      = "Update image workflow from ${var.owner}[bot] using Terraform"
#   overwrite_on_create = true
#   file                = ".github/workflows/image.yml"
#   content = templatefile("${path.module}/workflows/image.yml", {
#     name = var.name
#     ref  = "main"
#   })
#   # depends_on = [
#   #   github_repository_ruleset.default_branch
#   # ]
# }
resource "github_repository_file" "workflow" {
  for_each = {
    for name in local.active_workflows : name => local.workflows[name]
  }
  repository          = var.name
  branch              = local.repo.default_branch
  commit_message      = "Update image workflow from ${var.owner}[bot] using Terraform"
  overwrite_on_create = true
  file                = ".github/workflows/${each.key}.yml"
  content = (each.value.content != null ? each.value.content :
    templatefile("${path.module}/workflows/${each.key}.yml", {
      name  = var.name
      ref   = "main"
      cloud = var.cloud
      }
  ))
  # depends_on = [
  #   github_repository_ruleset.default_branch
  # ]
}
