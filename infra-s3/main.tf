terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Using local backend for candidate testing
  # backend "s3" {
  #   bucket = "pgr301-terraform-state"
  #   key    = "infra-s3/terraform.tfstate"
  #   region = "eu-west-1"
  # }
}

provider "aws" {
  region = var.aws_region
}

# S3 bucket for storing sentiment analysis results
resource "aws_s3_bucket" "analysis_data" {
  bucket = var.bucket_name

  tags = {
    Name        = "AiAlpha Analysis Data"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Enable versioning for data protection
resource "aws_s3_bucket_versioning" "analysis_data" {
  bucket = aws_s3_bucket.analysis_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle configuration for temporary files
resource "aws_s3_bucket_lifecycle_configuration" "analysis_data" {
  bucket = aws_s3_bucket.analysis_data.id

  rule {
    id     = "temp-files-lifecycle"
    status = "Enabled"

    filter {
      prefix = var.temp_prefix
    }

    # Transition temporary files to cheaper storage class after specified days
    transition {
      days          = var.days_to_glacier
      storage_class = "GLACIER"
    }

    # Delete temporary files after specified days
    expiration {
      days = var.days_to_expiration
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Optional: Rule for cleaning up old versions
  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }
}

# Block public access to bucket
resource "aws_s3_bucket_public_access_block" "analysis_data" {
  bucket = aws_s3_bucket.analysis_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "analysis_data" {
  bucket = aws_s3_bucket.analysis_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
