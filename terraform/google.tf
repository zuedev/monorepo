variable "google_credentials" {
  type      = string
  sensitive = true
}

provider "google" {
  project = "git-zue-dev-monorepo-opentofu"
  region  = "europe-west2"
  credentials = var.google_credentials
}
