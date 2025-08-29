resource "google_storage_bucket" "zuedev_backups" {
  name          = "zuedev-backups"
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true
}