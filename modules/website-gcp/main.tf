locals {
  # either the user gave a prefix or we build it and make the whole url
  domain = data.google_dns_managed_zone.this.dns_name # this has a dot at the end
  dns_prefix = coalesce(
    var.dns_prefix,
    "${var.tenant_name}-${var.name}"
  )
  hostname = "${local.dns_prefix}.${local.domain}"

  # a base id to find stuff in gcp
  base_name = "${local.dns_prefix}-website"

  # get the sites as a map, since they were a set, the order is preserved
  site_map = {
    for site in var.sites : coalesce(site.name, var.name) => site
  }
  # default_backend_name = tolist(var.sites)[0].name
  default_backend_name = keys(local.site_map)[0] # order should be maintained
  default_backend      = google_compute_backend_bucket.this[local.default_backend_name]
}

resource "google_compute_global_address" "this" {
  provider    = google
  name        = local.base_name
  description = "The global IP for the ${var.name} website in ${var.tenant_name}"
}

# Get the managed DNS zone
data "google_dns_managed_zone" "this" {
  provider = google
  name     = var.dns_zone_name
}

# Add the IP to the DNS
resource "google_dns_record_set" "this" {
  provider     = google
  name         = local.hostname
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.this.name
  rrdatas      = [google_compute_global_address.this.address]
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "this" {
  provider = google
  name     = local.base_name
  managed {
    domains = [google_dns_record_set.this.name]
  }
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "this" {
  for_each    = local.site_map
  provider    = google
  name        = "${var.tenant_name}-${each.key}"
  description = "${each.key} for GCS backend bucket ${each.value.bucket} in ${var.tenant_name} tenant"
  bucket_name = each.value.bucket
  enable_cdn  = true
}

# GCP URL MAP
resource "google_compute_url_map" "this" {
  provider        = google
  name            = local.base_name
  default_service = local.default_backend.id
  host_rule {
    hosts        = [trimsuffix(local.hostname, ".")]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = var.default_url_redirect == null ? local.default_backend.id : null
    dynamic "default_url_redirect" {
      for_each = var.default_url_redirect[*]
      content {
        host_redirect          = default_url_redirect.value.host_redirect
        https_redirect         = default_url_redirect.value.https_redirect
        path_redirect          = default_url_redirect.value.path_redirect
        redirect_response_code = default_url_redirect.value.redirect_response_code
        strip_query            = default_url_redirect.value.strip_query
      }
    }
    dynamic "path_rule" {
      for_each = local.site_map
      content {
        service = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/backendBuckets/gcs-bucket-${path_rule.value.bucket}"
        paths   = [path_rule.value.path]
      }
    }
  }
}

# GCP target proxy
resource "google_compute_target_https_proxy" "this" {
  provider         = google
  name             = local.base_name
  url_map          = google_compute_url_map.this.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.this.self_link]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  provider              = google
  name                  = local.base_name
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.this.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.this.self_link
}
