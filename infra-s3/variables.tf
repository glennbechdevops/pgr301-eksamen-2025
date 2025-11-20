variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for analysis data. Should be globally unique."
  type        = string

  validation {
    condition     = can(regex("^kandidat-[0-9]+-data$", var.bucket_name))
    error_message = "Bucket name must follow the pattern: kandidat-<number>-data"
  }
}

variable "temp_prefix" {
  description = "Prefix for temporary files that will be subject to lifecycle policies"
  type        = string
  default     = "midlertidig/"
}

variable "days_to_glacier" {
  description = "Number of days before temporary files are moved to Glacier storage"
  type        = number
  default     = 30

  validation {
    condition     = var.days_to_glacier >= 1
    error_message = "Days to Glacier must be at least 1"
  }
}

variable "days_to_expiration" {
  description = "Number of days before temporary files are permanently deleted"
  type        = number
  default     = 90

  validation {
    condition     = var.days_to_expiration > var.days_to_glacier
    error_message = "Days to expiration must be greater than days to Glacier"
  }
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days before noncurrent object versions are deleted"
  type        = number
  default     = 30
}
