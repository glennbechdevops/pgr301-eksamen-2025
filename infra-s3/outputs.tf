output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.analysis_data.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.analysis_data.arn
}

output "bucket_region" {
  description = "Region where the bucket is created"
  value       = aws_s3_bucket.analysis_data.region
}

output "lifecycle_policy_id" {
  description = "ID of the lifecycle policy for temporary files"
  value       = aws_s3_bucket_lifecycle_configuration.analysis_data.id
}

output "temp_prefix" {
  description = "Prefix used for temporary files"
  value       = var.temp_prefix
}

output "lifecycle_rules" {
  description = "Summary of lifecycle rules applied"
  value = {
    glacier_transition_days = var.days_to_glacier
    expiration_days         = var.days_to_expiration
  }
}
