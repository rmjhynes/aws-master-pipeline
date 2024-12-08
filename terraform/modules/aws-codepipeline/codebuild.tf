resource "aws_codebuild_project" "plan" {
  name          = "${var.pipeline_name}-terraform-plan"
  description   = "Generates a terraform plan and outputs it to a tfplan file."
  build_timeout = 5

  source {
    type      = "CODEPIPELINE"
    buildspec = file("../build_specs/buildspec_plan.yaml")

  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.plan.name
    }
  }

  service_role = aws_iam_role.codebuild_plan.arn
}

resource "aws_codebuild_project" "apply" {
  name          = "${var.pipeline_name}-terraform-apply"
  description   = "Applies the terraform configuration from a tfplan file."
  build_timeout = 5

  source {
    type      = "CODEPIPELINE"
    buildspec = file("../build_specs/buildspec_apply.yaml")
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.apply.name
    }
  }

  service_role = aws_iam_role.codebuild_apply.arn
}
