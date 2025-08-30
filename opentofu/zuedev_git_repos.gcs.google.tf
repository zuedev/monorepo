resource "google_storage_bucket" "zuedev_git_repos" {
  name          = "zuedev-git-repos"
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "read_only" {
  bucket = google_storage_bucket.zuedev_git_repos.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:saren-zue-dev@git-zue-dev-monorepo-opentofu.iam.gserviceaccount.com"
}
