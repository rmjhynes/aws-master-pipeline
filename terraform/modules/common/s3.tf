data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "shared_pipeline_artifact_bucket" {
  bucket = "shared-artifact-bucket-${data.aws_caller_identity.current.id}"

  // Force destroy the bucket and everything in it as we don't need it loitering
  // when the rest of the config is not deployed
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "artifact_public_access_block" {
  bucket = aws_s3_bucket.shared_pipeline_artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "artifact_bucket" {
  bucket = aws_s3_bucket.shared_pipeline_artifact_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowRootUserAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
        }
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.shared_pipeline_artifact_bucket.arn,
          "${aws_s3_bucket.shared_pipeline_artifact_bucket.arn}/*"
        ]
      },
      {
        Sid       = "AllowCode*Access"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.shared_pipeline_artifact_bucket.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:PrincipalAccount" = data.aws_caller_identity.current.id
          }
        }
      }
    ]
  })
}
