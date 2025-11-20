terraform {
  required_version = ">= 1.5"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# CloudWatch Dashboard for visualizing sentiment analysis metrics
resource "aws_cloudwatch_dashboard" "sentiment_dashboard" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      # Widget 1: Total Analysis Count (Counter metric)
      {
        type = "metric"
        properties = {
          metrics = [
            ["${var.cloudwatch_namespace}", "sentiment.analysis.total.count", { stat = "Sum", label = "Total Analyses" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Total Sentiment Analyses"
          period  = 300
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      # Widget 2: Analysis Duration (Timer metric)
      {
        type = "metric"
        properties = {
          metrics = [
            ["${var.cloudwatch_namespace}", "sentiment.analysis.duration", { stat = "Average", label = "Avg Duration" }],
            ["...", { stat = "Maximum", label = "Max Duration" }],
            ["...", { stat = "p99", label = "P99 Duration" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Analysis Duration (ms)"
          period  = 300
          yAxis = {
            left = {
              min = 0
              label = "Milliseconds"
            }
          }
        }
      },
      # Widget 3: Companies Detected (Gauge metric)
      {
        type = "metric"
        properties = {
          metrics = [
            ["${var.cloudwatch_namespace}", "sentiment.companies.detected", { stat = "Average" }]
          ]
          view    = "singleValue"
          region  = var.aws_region
          title   = "Companies Detected (Last)"
          period  = 300
        }
      },
      # Widget 4: Confidence Score Distribution (DistributionSummary)
      {
        type = "metric"
        properties = {
          metrics = [
            ["${var.cloudwatch_namespace}", "sentiment.confidence.score", { stat = "Average", label = "Avg Confidence" }],
            ["...", { stat = "Maximum", label = "Max Confidence" }],
            ["...", { stat = "Minimum", label = "Min Confidence" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Confidence Score Distribution (0-100)"
          period  = 300
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })
}

# SNS Topic for alarm notifications
resource "aws_sns_topic" "sentiment_alarms" {
  name = var.sns_topic_name
  
  tags = {
    Name        = "Sentiment Analysis Alarms"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# SNS Topic Subscription (email)
resource "aws_sns_topic_subscription" "alarm_email" {
  topic_arn = aws_sns_topic.sentiment_alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# CloudWatch Alarm: High average analysis duration
resource "aws_cloudwatch_metric_alarm" "high_duration" {
  alarm_name          = "${var.alarm_prefix}-high-duration"
  alarm_description   = "Triggers when average sentiment analysis duration exceeds threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "sentiment.analysis.duration"
  namespace           = var.cloudwatch_namespace
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.high_duration_threshold
  treat_missing_data  = "notBreaching"
  
  alarm_actions = [aws_sns_topic.sentiment_alarms.arn]
  ok_actions    = [aws_sns_topic.sentiment_alarms.arn]

  tags = {
    Name        = "High Analysis Duration"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# CloudWatch Alarm: Low confidence scores (optional second alarm)
resource "aws_cloudwatch_metric_alarm" "low_confidence" {
  count               = var.enable_confidence_alarm ? 1 : 0
  alarm_name          = "${var.alarm_prefix}-low-confidence"
  alarm_description   = "Triggers when confidence scores are consistently low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "sentiment.confidence.score"
  namespace           = var.cloudwatch_namespace
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.low_confidence_threshold
  treat_missing_data  = "notBreaching"
  
  alarm_actions = [aws_sns_topic.sentiment_alarms.arn]
  ok_actions    = [aws_sns_topic.sentiment_alarms.arn]

  tags = {
    Name        = "Low Confidence Scores"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
