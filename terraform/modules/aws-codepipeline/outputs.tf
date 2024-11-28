output "codepipeline_arn" {
  value = aws_codepipeline.pipeline.arn
}

output "codebuild_plan_arn" {
  value = aws_codebuild_project.plan.arn
}

output "codebuild_apply_arn" {
  value = aws_codebuild_project.apply.arn
}
