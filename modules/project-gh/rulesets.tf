resource "github_repository_ruleset" "this" {
  for_each    = data.github_repository.this
  name        = "default"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = 1
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }
  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }
  bypass_actors {
    actor_id    = nonsensitive(data.google_secret_manager_secret_version.github["app_id"].secret_data)
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    creation                = true
    update                  = true
    deletion                = true
    required_linear_history = true
    required_signatures     = false
    pull_request {
      required_approving_review_count = 1
    }
  }
  lifecycle {
    ignore_changes = [
      bypass_actors
    ]
  }
}
