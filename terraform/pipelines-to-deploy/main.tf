module "master_pipeline" {
  source = "../modules/aws-codepipeline/"

  for_each = toset(var.deployment_accounts)

  pipeline_name = var.pipeline_name
  account_id    = each.key
  repository_id = var.repository_id
}
