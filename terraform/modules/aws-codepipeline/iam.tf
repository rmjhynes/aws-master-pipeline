resource "aws_iam_role" "pipeline" {
  name = "${var.pipeline_name}-role"

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


resource "aws_iam_role_policy" "pipeline" {
  name = "${var.pipeline_name}-policy"
  role = aws_iam_role.pipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
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
        Sid    = "AccessCodeConnection"
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection"
        ]
        Resource = [
          data.aws_codestarconnections_connection.github_connection.arn
        ]
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
  name = "codebuild-plan-role"

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
  name = "codebuild-plan-policy"
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
      },
      {
        Sid    = "Logs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.id}:log-group:/aws/codebuild/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "codebuild_apply" {
  name = "codebuild-apply-role"

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
  name = "codebuild-apply-policy"
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
          "${aws_s3_bucket.pipeline_artifact_bucket.arn}/tfplan"
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
