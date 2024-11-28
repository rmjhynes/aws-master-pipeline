module "common" {
  source = "../modules/common/"
}

module "master_pipeline" {
  source = "../modules/aws-codepipeline/"

  for_each = toset(var.deployment_accounts)

  pipeline_name = var.pipeline_name
  account_id    = each.key
  repository_id = var.repository_id
  //artifact_bucket_id  = local.shared_pipeline_artifact_bucket.id
  //artifact_bucket_arn = local.shared_pipeline_artifact_bucket.arn
  //artifact_bucket_id  = module.common.shared_pipeline_artifact_bucket_id
  //artifact_bucket_arn = module.common.shared_pipeline_artifact_bucket_arn
  shared_pipeline_artifact_bucket = {
    id  = module.common.shared_pipeline_artifact_bucket_id
    arn = module.common.shared_pipeline_artifact_bucket_arn
  }
}
