resource "aws_s3_bucket" "zuedev_public_files" {
  bucket = "zuedev-public-files"
}

resource "aws_s3_bucket_public_access_block" "zuedev_public_files" {
  bucket = aws_s3_bucket.zuedev_public_files.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket.zuedev_public_files]
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.zuedev_public_files.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.zuedev_public_files.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket.zuedev_public_files,
    aws_s3_bucket_public_access_block.zuedev_public_files
  ]
}

resource "aws_s3_object" "test_json" {
  bucket       = aws_s3_bucket.zuedev_public_files.id
  key          = "test.json"
  content      = "{\"message\": \"This is a test JSON file uploaded by Terraform.\"}"
  content_type = "application/json"

  depends_on = [
    aws_s3_bucket.zuedev_public_files
  ]
}
