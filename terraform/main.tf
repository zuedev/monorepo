terraform {
  cloud {
    organization = "zuedev"
    workspaces {
      name = "zuedev-monorepo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "7.0.0"
    }
  }
}
