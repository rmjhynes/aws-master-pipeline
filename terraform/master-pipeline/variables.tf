variable "pipeline_name" {
  type = string
}

variable "repository_id" {
  type        = string
  description = "The repository which is used to trigger CodePipeline in the Source stage."
  default     = "rmjhynes/aws-master-pipeline"
}

//variable "working_dir" {
//  type        = string
//  description = "The directory of the terraform config to deploy."
//}
