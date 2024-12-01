variable "pipeline_name" {
  type = string
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "repository_id" {
  type        = string
  description = "The repository which is used to trigger CodePipeline in the Source stage."
}

variable "tf_version" {
  type    = string
  default = "1.10.0"
}

variable "shared_pipeline_artifact_bucket" {
  description = "Shared bucket artifact bucket data."
  type = object({
    id  = string
    arn = string
  })
}
