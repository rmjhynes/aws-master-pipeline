module "common" {
  source = "../modules/common/"
}

module "worker_pipelines" {
  source = "../modules/aws-codepipeline/"

  for_each      = var.pipelines
  pipeline_name = each.key
  account_id    = each.value.deployment_accounts[0]
  repository_id = each.value.code_repository
  shared_pipeline_artifact_bucket = {
    id  = module.common.shared_pipeline_artifact_bucket_id
    arn = module.common.shared_pipeline_artifact_bucket_arn
  }
}
