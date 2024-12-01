module "common" {
  source = "../modules/common/"
}

module "master_pipeline" {
  source = "../modules/aws-codepipeline/"

  pipeline_name = var.pipeline_name
  repository_id = var.repository_id
  shared_pipeline_artifact_bucket = {
    id  = module.common.shared_pipeline_artifact_bucket_id
    arn = module.common.shared_pipeline_artifact_bucket_arn
  }
}
