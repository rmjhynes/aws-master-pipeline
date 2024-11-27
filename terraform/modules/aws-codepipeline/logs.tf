resource "aws_cloudwatch_log_group" "plan" {
  name              = "/aws/codebuild/${var.pipeline_name}-terraform-plan"
  retention_in_days = "1"
}

resource "aws_cloudwatch_log_group" "apply" {
  name              = "/aws/codebuild/${var.pipeline_name}-terraform-apply"
  retention_in_days = "1"
}

