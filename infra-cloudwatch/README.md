# CloudWatch Observability Infrastructure

This Terraform configuration creates CloudWatch dashboards and alarms for monitoring the AiAlpha sentiment analysis application.

## What This Creates

### CloudWatch Dashboard
A comprehensive dashboard visualizing key metrics:

1. **Total Sentiment Analyses** (Counter)
   - Tracks total number of API calls over time
   - Shows request volume trends

2. **Analysis Duration** (Timer)
   - Average, maximum, and P99 response times
   - Helps identify performance degradation

3. **Companies Detected** (Gauge)
   - Current number of companies in latest analysis
   - Shows typical analysis complexity

4. **Confidence Score Distribution** (DistributionSummary)
   - Average, min, and max confidence scores
   - Indicates model confidence trends

### CloudWatch Alarms

1. **High Duration Alarm**
   - Triggers when average analysis time exceeds threshold (default: 5000ms)
   - Helps catch performance issues early

2. **Low Confidence Alarm** (optional)
   - Triggers when confidence scores are consistently low (default: <50)
   - Indicates potential model quality issues

### SNS Topic
- Email notifications for all alarm state changes
- Requires email confirmation after deployment

## Prerequisites

- Terraform >= 1.5
- AWS credentials configured
- Application running and sending metrics to CloudWatch
- Valid email address for notifications

## Usage

### Initial Setup

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` and set your email:
   ```hcl
   alarm_email = "your-email@student.kristiania.no"
   ```

3. **Important:** Ensure the `cloudwatch_namespace` matches your MetricsConfig.java:
   ```hcl
   cloudwatch_namespace = "kandidat26"  # Must match Java config
   ```

### Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply
```

### Confirm SNS Subscription

After deploying, you'll receive an email titled **"AWS Notification - Subscription Confirmation"**.

**You MUST click the confirmation link** in the email for alarms to work!

### View Dashboard

After deployment, Terraform outputs the dashboard URL. Navigate to:
```
https://console.aws.amazon.com/cloudwatch/home?region=eu-west-1#dashboards:name=kandidat-26-sentiment-dashboard
```

## Testing Alarms

### Test High Duration Alarm

The alarm triggers when average analysis duration exceeds 5000ms over 2 consecutive 5-minute periods.

**Option 1: Natural trigger (if application is slow)**
- Run the application
- Make API requests
- Wait for metrics to accumulate

**Option 2: Manual trigger using AWS CLI**
```bash
aws cloudwatch set-alarm-state \
  --alarm-name kandidat-26-high-duration \
  --state-value ALARM \
  --state-reason "Testing alarm notification"
```

This immediately triggers the alarm and sends an email.

### Test Low Confidence Alarm

Similar approach - either wait for naturally low confidence scores or manually trigger:

```bash
aws cloudwatch set-alarm-state \
  --alarm-name kandidat-26-low-confidence \
  --state-value ALARM \
  --state-reason "Testing alarm notification"
```

### Reset Alarm to OK State

```bash
aws cloudwatch set-alarm-state \
  --alarm-name kandidat-26-high-duration \
  --state-value OK \
  --state-reason "Test complete"
```

## Configuration

### Alarm Thresholds

You can adjust thresholds in `terraform.tfvars`:

```hcl
# Trigger if average duration > 5 seconds
high_duration_threshold = 5000

# Trigger if average confidence < 50%
low_confidence_threshold = 50

# Alarm evaluates over 2 periods (10 minutes total)
alarm_evaluation_periods = 2
```

### Alarm Sensitivity

- **Period**: 300 seconds (5 minutes)
- **Evaluation Periods**: 2
- **Total time to alarm**: 10 minutes of sustained threshold breach

This configuration avoids false positives from brief spikes while catching sustained issues.

## Troubleshooting

### No metrics appearing in dashboard

1. **Check namespace matches Java code:**
   ```java
   // In MetricsConfig.java
   "cloudwatch.namespace", "kandidat26"
   ```

2. **Verify application is running and receiving requests**

3. **Check CloudWatch Metrics in AWS Console:**
   - Go to CloudWatch → Metrics → All metrics
   - Look for your namespace ("kandidat26")

4. **Metrics take time to appear** (5-10 minutes delay is normal)

### Alarms not sending emails

1. **Check SNS subscription is confirmed:**
   ```bash
   aws sns list-subscriptions-by-topic \
     --topic-arn <your-topic-arn>
   ```
   Status should be "Confirmed"

2. **Check spam folder** for confirmation email

3. **Manually trigger alarm** to test notification

### Dashboard shows "No data"

- Metrics need time to accumulate (5-15 minutes)
- Ensure application has processed at least a few requests
- Verify namespace is correct

## Alarm Notification Examples

When an alarm triggers, you'll receive an email like:

```
AWS Alarm: kandidat-26-high-duration in EU (Ireland)

Alarm Details:
- New State: ALARM
- Reason: Threshold Crossed: 1 datapoint [5234.5] was greater than the threshold (5000.0)
- Timestamp: 2025-01-15T10:30:00.000+0000
```

When it recovers:

```
AWS Alarm: kandidat-26-high-duration in EU (Ireland)

Alarm Details:
- New State: OK
- Reason: Threshold Crossed: 2 datapoints [3245.2, 2890.1] were not greater than the threshold (5000.0)
```

## Cost Considerations

This infrastructure has minimal cost:
- CloudWatch Dashboard: Free (first 3 dashboards)
- CloudWatch Alarms: $0.10 per alarm per month
- SNS Email: Free (first 1000 notifications)
- Metrics: Included with application

**Estimated monthly cost: ~$0.20**

## Cleanup

To remove all infrastructure:

```bash
terraform destroy
```

**Note:** This doesn't delete historical metric data in CloudWatch.

## Deliverables for Exam

For Oppgave 4B, ensure you have:

1. ✅ Complete Terraform code in this directory
2. ✅ Screenshot of dashboard with real metrics
3. ✅ Screenshot of triggered alarm
4. ✅ Screenshot of SNS email notification
5. ✅ Documentation of threshold choices

## Additional Resources

- [CloudWatch Metrics Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)
- [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
- [Micrometer CloudWatch Registry](https://micrometer.io/docs/registry/cloudwatch)
