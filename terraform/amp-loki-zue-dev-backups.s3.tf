resource "aws_s3_bucket" "amp_loki_zue_dev_backups" {
  bucket = "amp-loki-zue-dev-backups"
}

resource "aws_iam_user" "amp_loki_zue_dev_backups_user" {
  name = "amp-loki-zue-dev-backups-user"
}

resource "aws_iam_user_policy" "amp_loki_zue_dev_backups_user_policy" {
  name = "amp-loki-zue-dev-backups-user-policy"
  user = aws_iam_user.amp_loki_zue_dev_backups_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = aws_s3_bucket.amp_loki_zue_dev_backups.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.amp_loki_zue_dev_backups.arn}/*"
      }
    ]
  })
}