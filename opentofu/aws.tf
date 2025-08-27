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
