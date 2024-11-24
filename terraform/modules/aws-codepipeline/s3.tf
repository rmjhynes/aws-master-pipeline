data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "pipeline_artifact_bucket" {
  bucket = "${var.pipeline_name}-artifact-bucket-${data.aws_caller_identity.current.id}"
}

resource "aws_s3_bucket_public_access_block" "artifact_public_access_block" {
  bucket = aws_s3_bucket.pipeline_artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "artifact_bucket" {
  bucket = aws_s3_bucket.pipeline_artifact_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowRootUserAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam:::${var.account_id}:root"
        }
        Action = ["s3:*"
        ]
        Resource = [
          "arn:aws:s3:::pipeline_artifact_bucket",
          "arn:aws:s3:::pipeline_artifact_bucket/*"
        ]
      },
      {
        Sid    = "AllowCodePipelineAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_codepipeline.pipeline.arn
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::pipeline_artifact_bucket",
          "arn:aws:s3:::pipeline_artifact_bucket/*"
        ]
      }
    ]
  })
}
