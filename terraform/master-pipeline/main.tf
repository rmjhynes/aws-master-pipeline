module "master_pipeline" {
  source = "../modules/aws-codepipeline/"

  pipeline_name = "master-pipeline"
  repository_id = "rmjhynes/aws-master-pipeline"
  account_id    = var.account_id
}
