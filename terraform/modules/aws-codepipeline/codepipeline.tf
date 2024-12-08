resource "aws_codepipeline" "pipeline" {
  name          = var.pipeline_name
  role_arn      = aws_iam_role.pipeline.arn
  pipeline_type = "V2"

  artifact_store {
    location = var.shared_pipeline_artifact_bucket.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_code"]

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
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_code"]
      output_artifacts = ["tfplan"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.plan.name
        EnvironmentVariables = jsonencode([
          {
            name  = "TF_VERSION"
            value = var.tf_version
          },
          {
            name  = "BACKEND_CONFIG_REGION"
            value = data.aws_region.current.id
          },
          {
            name  = "BACKEND_CONFIG_BUCKET"
            value = "terraform-state-${data.aws_caller_identity.current.id}"
          },
          {
            name  = "BACKEND_CONFIG_KEY"
            value = "${var.pipeline_name}.tfstate"
          },
          {
            name  = "WORKING_DIR"
            value = var.working_dir
          }
        ])
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "ManualApproval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
      configuration = {
        CustomData = "Please review the proposed configuration changes outlined in the Terraform plan in the previous stage."
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "TerraformApply"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "source_code",
        "tfplan"
      ]
      version = "1"

      configuration = {
        ProjectName   = aws_codebuild_project.apply.name
        PrimarySource = "source_code"
        EnvironmentVariables = jsonencode([
          {
            name  = "TF_VERSION"
            value = var.tf_version
          },
          {
            name  = "BACKEND_CONFIG_REGION"
            value = data.aws_region.current.id
          },
          {
            name  = "BACKEND_CONFIG_BUCKET"
            value = "terraform-state-${data.aws_caller_identity.current.id}"
          },
          {
            name  = "BACKEND_CONFIG_KEY"
            value = "${var.pipeline_name}.tfstate"
          },
          {
            name  = "WORKING_DIR"
            value = var.working_dir
          }
        ])

      }
    }
  }
}
