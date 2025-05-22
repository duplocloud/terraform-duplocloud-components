locals {
  default_backend = tolist(var.sites)[0].name
  site_map = {
    for site in var.sites : site.name => site
  }
}

resource "google_compute_global_address" "website" {
  provider = google
  name     = "${var.tenant_name}${var.global_address_name_suffix}"
}

# Get the managed DNS zone
data "google_dns_managed_zone" "cloud_dns" {
  provider = google
  name     = var.dns_zone_name
}

# Add the IP to the DNS
resource "google_dns_record_set" "website" {
  provider     = google
  name         = var.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.cloud_dns.name
  rrdatas      = [google_compute_global_address.website.address]
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "website" {
  provider = google
  name     = var.cert_name
  managed {
    domains = [google_dns_record_set.website.name]
  }
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "website" {
  for_each    = local.site_map
  provider    = google
  name        = "gcs-bucket-${each.key}"
  description = "${each.key} for GCS backend bucket ${each.value.bucket}"
  bucket_name = each.value.bucket
  enable_cdn  = true
}

# GCP URL MAP
resource "google_compute_url_map" "website" {
  provider        = google
  name            = var.url_map_name
  default_service = google_compute_backend_bucket.website.0.id
  host_rule {
    hosts        = [trimsuffix(var.dns_name, ".")]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = var.default_url_redirect == null ? google_compute_backend_bucket.website[local.default_backend].id : null
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
resource "google_compute_target_https_proxy" "website" {
  provider         = google
  name             = var.proxy_name
  url_map          = google_compute_url_map.website.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  provider              = google
  name                  = var.proxy_name
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website.self_link
}
