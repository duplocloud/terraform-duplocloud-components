resource "github_repository" "this" {
  count                       = var.mode == "resource" ? 1 : 0
  name                        = var.name
  description                 = var.description
  visibility                  = var.visibility
  vulnerability_alerts        = true
  has_downloads               = true
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  web_commit_signoff_required = true
}

data "github_repository_custom_properties" "this" {
  count      = var.mode == "data" ? 1 : 0
  repository = var.name
}

data "github_repository" "this" {
  count     = var.mode == "data" ? 1 : 0
  name      = var.owner == null ? var.name : null
  full_name = var.owner != null ? "${var.owner}/${var.name}" : null
}
