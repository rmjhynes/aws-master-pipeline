variable "pipelines" {
  type = map(object({
    code_repository = string
  }))
}
