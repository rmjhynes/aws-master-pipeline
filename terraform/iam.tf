resource "aws_iam_role" "master_pipeline" {
  name = "master_pipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CodePipelineAssumeRole"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "master_pipeline" {
  name = "master_pipeline_policy"
  role = aws_iam_role.master_pipeline.id

  policy = jsonencode({
    Version = "V2012-10-17"
    Statement = [
      {
        Sid = "AccessS3"
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.pipeline_artifact_bucket.arn
      },
      {
        Sid = "ControlCodeBuild"
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


resource "aws_iam_role" "codebuild_plan" {
  name = "codebuild_plan_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "CodeBuildAssumeRole"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_plan" {
  name = "codebuild_plan_policy"
  role = aws_iam_role.codebuild_plan.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ReadAWSEnvironment"
        Action = [
          "iam:Get*",
          "iam:List*"
        ]
        Effect   = "Allow"
        Resource = "*"

      },
      {
        Sid = "AccessS3"
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.pipeline_artifact_bucket.arn
      }
    ]
  })
}


resource "aws_iam_role" "codebuild_apply" {
  name = "codebuild_apply_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_apply" {
  name = "codebuild_apply_policy"
  role = aws_iam_role.codebuild_apply.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ReadS3"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.pipeline_artifact_bucket.arn,
          "arn:aws:s3:::$(aws_s3_bucket.pipeline_artifact_bucket.arn)/tfplan"
        ]
      },
      {
        Sid = "ApplyTerraformConfig"
        Action = [
          "iam:*",
        ]
        Effect   = "Allow"
        Resource = "*"

      }
    ]
  })
}
