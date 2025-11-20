# AiAlpha Sentiment Analysis API

AI-powered sentiment analysis API using AWS Bedrock Nova for company-specific sentiment detection.

## Features

- **Company-specific sentiment analysis** using AWS Bedrock Nova Micro
- **Structured sentiment results** with confidence scores and reasoning
- **S3 storage** for analysis results
- **CloudWatch metrics** for observability
- **REST API** for easy integration

## Technology Stack

- **Java 21** with Spring Boot 3.2
- **AWS Bedrock** for AI-powered analysis
- **AWS S3** for result storage
- **Micrometer** for metrics collection
- **Docker** for containerization

## Quick Start

### Prerequisites

- Docker installed
- AWS credentials with access to Bedrock and S3
- S3 bucket for storing results

### Running with Docker

```bash
docker pull <your-dockerhub-username>/sentiment-docker:latest

docker run -e AWS_ACCESS_KEY_ID=your-access-key \
  -e AWS_SECRET_ACCESS_KEY=your-secret-key \
  -e S3_BUCKET_NAME=kandidat-26-data \
  -p 8080:8080 \
  <your-dockerhub-username>/sentiment-docker:latest
```

### Building Locally

```bash
# Build Docker image
docker build -t sentiment-docker .

# Run container
docker run -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e S3_BUCKET_NAME=kandidat-26-data \
  -p 8080:8080 sentiment-docker
```

## API Usage

### Analyze Sentiment

**Endpoint:** `POST /api/analyze`

**Request:**
```json
{
  "requestId": "test-123",
  "text": "NVIDIA soars while Intel struggles with declining sales"
}
```

**Response:**
```json
{
  "requestId": "test-123",
  "timestamp": "2025-01-15T10:30:00Z",
  "companies": [
    {
      "company": "NVIDIA",
      "sentiment": "POSITIVE",
      "confidence": 0.95,
      "reasoning": "Strong stock performance indicated by 'soars'"
    },
    {
      "company": "INTEL",
      "sentiment": "NEGATIVE",
      "confidence": 0.88,
      "reasoning": "Struggling with declining sales"
    }
  ],
  "s3Location": "s3://kandidat-26-data/sentiment-results/20250115-103000-test-123.json"
}
```

### Health Check

**Endpoint:** `GET /actuator/health`

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `AWS_ACCESS_KEY_ID` | AWS access key | Yes |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | Yes |
| `S3_BUCKET_NAME` | S3 bucket for results | Yes |
| `AWS_REGION` | AWS region | No (default: eu-west-1) |

## Metrics

The application exports metrics to CloudWatch:

- `sentiment.analysis.count` - Total number of analyses
- `sentiment.api.latency` - API response time
- `sentiment.bedrock.latency` - AWS Bedrock call duration
- `sentiment.confidence.distribution` - Distribution of confidence scores

## Architecture

This application demonstrates modern DevOps practices:

- **Multi-stage Docker builds** for optimized image size
- **Non-root container user** for security
- **Health checks** for container orchestration
- **Metrics and observability** with CloudWatch
- **CI/CD pipeline** with GitHub Actions

## License

Educational project for PGR301 DevOps course.
# Test deployment
