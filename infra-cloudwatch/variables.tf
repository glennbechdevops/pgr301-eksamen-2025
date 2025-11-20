variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-1"
}

variable "cloudwatch_namespace" {
  description = "CloudWatch namespace where metrics are published (must match MetricsConfig)"
  type        = string
  default     = "kandidat26"
}

variable "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
  default     = "kandidat-26-sentiment-dashboard"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for alarm notifications"
  type        = string
  default     = "kandidat-26-sentiment-alarms"
}

variable "alarm_email" {
  description = "Email address to receive alarm notifications"
  type        = string
}

variable "alarm_prefix" {
  description = "Prefix for alarm names"
  type        = string
  default     = "kandidat-26"
}

variable "alarm_period" {
  description = "Period in seconds for alarm evaluation"
  type        = number
  default     = 300
  
  validation {
    condition     = var.alarm_period >= 60
    error_message = "Alarm period must be at least 60 seconds"
  }
}

variable "alarm_evaluation_periods" {
  description = "Number of periods to evaluate before triggering alarm"
  type        = number
  default     = 2
  
  validation {
    condition     = var.alarm_evaluation_periods >= 1
    error_message = "Evaluation periods must be at least 1"
  }
}

variable "high_duration_threshold" {
  description = "Threshold in milliseconds for high duration alarm"
  type        = number
  default     = 5000
  
  validation {
    condition     = var.high_duration_threshold > 0
    error_message = "Duration threshold must be positive"
  }
}

variable "enable_confidence_alarm" {
  description = "Whether to enable the low confidence alarm"
  type        = bool
  default     = true
}

variable "low_confidence_threshold" {
  description = "Threshold for low confidence alarm (0-100 scale)"
  type        = number
  default     = 50
  
  validation {
    condition     = var.low_confidence_threshold >= 0 && var.low_confidence_threshold <= 100
    error_message = "Confidence threshold must be between 0 and 100"
  }
}
