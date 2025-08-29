resource "google_storage_bucket" "zuedev_git_repos" {
  name          = "zuedev-git-repos"
  location      = "EUROPE-WEST2"
  force_destroy = true

  uniform_bucket_level_access = true
}