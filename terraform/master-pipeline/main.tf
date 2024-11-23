module "master_pipeline" {
  source = "../modules/aws-codepipeline/"

  pipeline_name = "master-pipeline"
}
