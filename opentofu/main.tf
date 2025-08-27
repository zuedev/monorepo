terraform {
  backend "s3" {
    bucket       = "git-zue-dev-monorepo-opentofu-state"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "git-zue-dev-monorepo-opentofu-state" {
  bucket = "git-zue-dev-monorepo-opentofu-state"
}

resource "aws_s3_bucket_versioning" "git-zue-dev-monorepo-opentofu-state" {
  bucket = aws_s3_bucket.git-zue-dev-monorepo-opentofu-state.id

  versioning_configuration {
    status = "Enabled"
  }
}
