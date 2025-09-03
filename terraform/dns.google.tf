resource "google_dns_managed_zone" "gcp-zue-dev" {
  name     = "gcp-zue-dev"
  dns_name = "gcp.zue.dev."
}
