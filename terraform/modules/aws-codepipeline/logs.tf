resource "aws_cloudwatch_log_group" "plan" {
  name              = "/aws/codebuild/terraform-plan"
  retention_in_days = "1"
}
