variable "pipeline_name" {
  type = string
}

variable "repository_id" {
  type        = string
  description = "The repository which is used to trigger CodePipeline in the Source stage."
  default     = "rmjhynes/aws-master-pipeline"
}
