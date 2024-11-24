data "aws_codestarconnections_connection" "github_connection" {
  name = "aws-master-pipeline-connection"
}

resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    // Source the code to deploy from this repo (aws-master-pipeline) on pushes to main
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = var.repository_id
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Teraform plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["tfplan_file"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.plan.name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "Manual approval of tfplan"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Terraform apply"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["tfplan_file"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.apply.name
      }
    }
  }
}

resource "aws_codebuild_project" "plan" {
  name          = "terraform-plan"
  description   = "Generates a terraform plan and outputs it to a tfplan file."
  build_timeout = 5

  source {
    type      = "CODEPIPELINE"
    buildspec = "build_specs/buildspec_plan.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  service_role = aws_iam_role.codebuild_plan.arn
}

resource "aws_codebuild_project" "apply" {
  name          = "terraform-apply"
  description   = "Applies the terraform configuration from a tfplan file."
  build_timeout = 5

  source {
    type      = "CODEPIPELINE"
    buildspec = "build_specs/buildspec_apply.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  service_role = aws_iam_role.codebuild_apply.arn
}

