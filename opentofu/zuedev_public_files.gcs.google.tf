resource "google_storage_bucket" "public_files" {
  name          = "zuedev-public-files"
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.public_files.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_object" "test_json" {
  name   = "test.json"
  bucket = google_storage_bucket.public_files.name
  content = jsonencode({
    message = "This is a test object"
    status  = "success"
  })
  content_type = "application/json"
}
