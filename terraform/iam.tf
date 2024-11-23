resource "aws_iam_role" "master_pipeline" {
  name = "master_pipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "s3"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:*"
          ]
          Effect   = "Allow"
          Resource = aws_s3_bucket.pipeline_artifact_bucket.arn
        },
        {
          Action = [
            "codebuild:*"
          ]
          Effect = "Allow"
          Resource = [
            aws_codebuild_project.plan.arn,
            aws_codebuild_project.apply.arn
          ]
        }
      ]
    })
  }
}
