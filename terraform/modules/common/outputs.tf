output "shared_pipeline_artifact_bucket_id" {
  value = aws_s3_bucket.shared_pipeline_artifact_bucket.id
}

output "shared_pipeline_artifact_bucket_arn" {
  value = aws_s3_bucket.shared_pipeline_artifact_bucket.arn
}
