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

variable "account_id" {
  type = string
}

variable "tf_version" {
  type    = string
  default = "1.9.8"
}

