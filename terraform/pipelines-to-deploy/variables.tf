variable "pipelines" {
  type = map(object({
    deployment_accounts = list(string)
    code_repository     = string
  }))
}
