data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_codestarconnections_connection" "github_connection" {
  name = "aws-master-pipeline-connection"
}
