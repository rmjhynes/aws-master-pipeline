variable "deployment_accounts" {
  description = "A list containing the Account IDs in which the master pipeline should be deployed."
  type        = list(string)
}

variable "pipeline_name" {
  type = string
}

variable "repository_id" {
  type        = string
  description = "The repository which is used to trigger CodePipeline in the Source stage."
  default     = "rmjhynes/aws-master-pipeline"
}
