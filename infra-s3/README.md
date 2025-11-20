# S3 Infrastructure for AiAlpha Analysis Data

This Terraform configuration creates and manages an S3 bucket for storing sentiment analysis results with lifecycle policies for automatic data management.

## Architecture

The infrastructure includes:

- **S3 Bucket**: Primary storage for analysis results (`kandidat-<number>-data`)
- **Lifecycle Policies**: Automated management of temporary files
  - Files under `midlertidig/` prefix are automatically transitioned to Glacier after 30 days
  - Files are permanently deleted after 90 days
  - Files outside `midlertidig/` remain permanent
- **Security Features**:
  - Versioning enabled for data protection
  - Public access blocked
  - Server-side encryption (AES256)
  - Cleanup of incomplete multipart uploads

## Prerequisites

- Terraform >= 1.5
- AWS credentials configured (via environment variables or AWS CLI)
- Access to the `pgr301-terraform-state` bucket for state management

## Usage

### Initial Setup

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` and replace `XXX` with your candidate number:
   ```hcl
   bucket_name = "kandidat-123-data"  # Replace 123 with your number
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

### Validation and Planning

Check the configuration is valid:
```bash
terraform fmt -check
terraform validate
terraform plan
```

### Deployment

Apply the infrastructure:
```bash
terraform apply
```

Review the plan and type `yes` to confirm.

### Verification

After deployment, verify the bucket was created:
```bash
aws s3 ls | grep kandidat
```

Check lifecycle policies:
```bash
aws s3api get-bucket-lifecycle-configuration --bucket kandidat-XXX-data
```

## Lifecycle Policy Details

### Temporary Files (`midlertidig/` prefix)

Files stored under the `midlertidig/` prefix follow this lifecycle:

1. **Day 0-29**: Standard storage (S3 Standard)
2. **Day 30**: Automatically moved to Glacier storage (cheaper, slower access)
3. **Day 90**: Permanently deleted

### Permanent Files

Files stored outside the `midlertidig/` prefix are not affected by lifecycle rules and remain in the bucket indefinitely.

## Configuration Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `bucket_name` | S3 bucket name (must match pattern: kandidat-XXX-data) | - | Yes |
| `aws_region` | AWS region | eu-west-1 | No |
| `temp_prefix` | Prefix for temporary files | midlertidig/ | No |
| `days_to_glacier` | Days before moving to Glacier | 30 | No |
| `days_to_expiration` | Days before deletion | 90 | No |

## Outputs

After applying, Terraform will output:

- `bucket_name`: The name of the created bucket
- `bucket_arn`: The ARN of the bucket
- `bucket_region`: The region where the bucket is created
- `lifecycle_policy_id`: The ID of the lifecycle configuration
- `temp_prefix`: The prefix used for temporary files
- `lifecycle_rules`: Summary of lifecycle rules

## Cost Optimization

The lifecycle policy helps reduce storage costs by:

1. **Glacier Transition**: Moving old temporary files to cheaper storage (~82% cost reduction)
2. **Automatic Deletion**: Removing temporary files after they're no longer needed
3. **Version Cleanup**: Removing old object versions after 30 days

## State Management

Terraform state is stored remotely in the `pgr301-terraform-state` S3 bucket:
- **Bucket**: pgr301-terraform-state
- **Key**: infra-s3/terraform.tfstate
- **Region**: eu-west-1

This enables team collaboration and prevents state conflicts.

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

⚠️ **Warning**: This will delete the bucket and all its contents. Make sure to backup any important data first.

## Troubleshooting

### Bucket name already exists
If you get an error about the bucket name being taken, verify your candidate number and ensure the bucket doesn't already exist.

### Access denied
Ensure your AWS credentials have the necessary permissions:
- s3:CreateBucket
- s3:PutBucketLifecycleConfiguration
- s3:PutBucketVersioning
- s3:PutBucketPublicAccessBlock

### State bucket not accessible
Verify you have access to the `pgr301-terraform-state` bucket. If not, you can remove the backend configuration temporarily and use local state.
