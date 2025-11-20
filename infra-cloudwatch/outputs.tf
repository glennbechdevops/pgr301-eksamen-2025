output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.sentiment_dashboard.dashboard_name
}

output "dashboard_url" {
  description = "URL to the CloudWatch dashboard"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.sentiment_dashboard.dashboard_name}"
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  value       = aws_sns_topic.sentiment_alarms.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic"
  value       = aws_sns_topic.sentiment_alarms.name
}

output "high_duration_alarm_name" {
  description = "Name of the high duration alarm"
  value       = aws_cloudwatch_metric_alarm.high_duration.alarm_name
}

output "low_confidence_alarm_name" {
  description = "Name of the low confidence alarm (if enabled)"
  value       = var.enable_confidence_alarm ? aws_cloudwatch_metric_alarm.low_confidence[0].alarm_name : "Not enabled"
}

output "alarm_email" {
  description = "Email address configured for alarm notifications"
  value       = var.alarm_email
  sensitive   = true
}

output "cloudwatch_namespace" {
  description = "CloudWatch namespace used for metrics"
  value       = var.cloudwatch_namespace
}
