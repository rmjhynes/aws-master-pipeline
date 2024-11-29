module "common" {
  source = "../modules/common/"
}

module "master_pipeline" {
  source = "../modules/aws-codepipeline/"

  for_each = toset(var.deployment_accounts)

  pipeline_name = var.pipeline_name
  account_id    = each.key
  repository_id = var.repository_id
  shared_pipeline_artifact_bucket = {
    id  = module.common.shared_pipeline_artifact_bucket_id
    arn = module.common.shared_pipeline_artifact_bucket_arn
  }
}
