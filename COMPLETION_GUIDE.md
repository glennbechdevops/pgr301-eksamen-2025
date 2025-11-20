# PGR301 Exam Completion Guide

This guide helps you complete and submit your PGR301 exam solution.

## ✅ What's Been Completed

All code and infrastructure has been created. You now need to:
1. Configure secrets and credentials
2. Deploy and test the solutions
3. Document results with screenshots
4. Commit and push everything to GitHub

---

## 📋 Step-by-Step Completion Checklist

### Step 1: Update Candidate Information

Update `README_SVAR.md` with your details:
- Replace `[FYLL INN DITT KANDIDATNUMMER]` with **26**
- Add your GitHub repository URL

### Step 2: Configure AWS Credentials

You'll need AWS credentials for testing and GitHub Actions.

**Option A: For Local Testing** (temporary):
```bash
export AWS_ACCESS_KEY_ID="your-access-key-here"
export AWS_SECRET_ACCESS_KEY="your-secret-key-here"
export AWS_REGION="eu-west-1"
```

**Option B: Configure AWS CLI** (permanent):
```bash
aws configure
# Enter your credentials when prompted
```

### Step 3: Add GitHub Secrets

Go to your GitHub repository:
1. Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add these secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `DOCKER_USERNAME` (your Docker Hub username)
   - `DOCKER_TOKEN` (Docker Hub access token)

**Getting Docker Hub Token:**
1. Go to https://hub.docker.com/
2. Login or create account (free)
3. Account Settings → Security → New Access Token
4. Copy the token (shown only once!)

### Step 4: Test Oppgave 1 (Terraform S3)

```bash
cd infra-s3
terraform init
terraform plan
terraform apply
```

Verify bucket was created:
```bash
aws s3 ls | grep kandidat-26
```

### Step 5: Deploy Oppgave 2 (SAM Application)

The SAM application is already configured. To deploy:

**Option A: Via GitHub Actions** (recommended):
1. Commit and push all changes to `main` branch
2. GitHub Actions will automatically deploy
3. Check Actions tab for workflow results
4. Get API URL from workflow output

**Option B: Manual deployment**:
```bash
cd sam-comprehend
sam build
sam deploy --guided
# Follow prompts, use stack name: kandidat-26-sentiment
```

Test the API:
```bash
curl -X POST <YOUR-API-URL>/analyze \
  -H "Content-Type: application/json" \
  -d '{"text": "Apple launches groundbreaking AI while Microsoft faces security concerns"}'
```

### Step 6: Test Oppgave 3 (Docker)

The Docker image builds successfully locally. To push to Docker Hub:

1. **Ensure secrets are configured** (Step 3)
2. **Commit and push** changes in `sentiment-docker/` to trigger workflow
3. **Or manually push:**
   ```bash
   cd sentiment-docker
   docker build -t <your-dockerhub-username>/sentiment-docker:latest .
   docker login
   docker push <your-dockerhub-username>/sentiment-docker:latest
   ```

Test the container (requires AWS credentials):
```bash
docker run -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e S3_BUCKET_NAME=kandidat-26-data \
  -p 8080:8080 \
  <your-dockerhub-username>/sentiment-docker:latest
```

Then test the API:
```bash
curl -X POST http://localhost:8080/api/analyze \
  -H "Content-Type: application/json" \
  -d '{"requestId":"test-1","text":"NVIDIA soars while Intel struggles"}'
```

### Step 7: Deploy Oppgave 4 (CloudWatch)

#### Part A: Metrics (Already Implemented)
The custom metrics are implemented in `SentimentMetrics.java`:
- ✅ Counter: `sentiment.analysis.total`
- ✅ Timer: `sentiment.analysis.duration`
- ✅ Gauge: `sentiment.companies.detected`
- ✅ DistributionSummary: `sentiment.confidence.score`

To see metrics, run the application and make requests (see Step 6).

#### Part B: CloudWatch Infrastructure

1. **Configure email**:
   ```bash
   cd infra-cloudwatch
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars and add your email
   ```

2. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Confirm SNS subscription** - Check your email and click confirmation link!

4. **View dashboard**:
   - Go to AWS Console → CloudWatch → Dashboards
   - Look for `kandidat-26-sentiment-dashboard`

5. **Test alarm** (manual trigger):
   ```bash
   aws cloudwatch set-alarm-state \
     --alarm-name kandidat-26-high-duration \
     --state-value ALARM \
     --state-reason "Testing alarm"
   ```

6. **Take screenshots** for README_SVAR.md:
   - Dashboard with metrics visible
   - Alarm in ALARM state
   - Email notification received

### Step 8: Document Everything in README_SVAR.md

Update `README_SVAR.md` with:

#### Oppgave 1:
- ✅ Terraform code location
- ✅ Workflow file
- ❌ Add: Link to successful workflow run (after pushing to GitHub)

#### Oppgave 2:
- ❌ Add API Gateway URL (from SAM deploy output)
- ❌ Add S3 object path example
- ❌ Add link to successful deploy workflow
- ❌ Add link to PR with validation-only

#### Oppgave 3:
- ❌ Add Docker Hub image name
- ❌ Add link to successful build workflow
- ❌ Explain your tagging strategy choice
- ❌ Update sensor instructions with your Docker username

#### Oppgave 4:
- ❌ Add screenshot: CloudWatch metrics
- ❌ Add screenshot: Dashboard
- ❌ Add screenshot: Triggered alarm
- ❌ Add screenshot: Email notification
- ❌ Explain metric implementations
- ❌ Document alarm threshold reasoning

#### Oppgave 5:
- ✅ Essay completed (800 words)

### Step 9: Create a Test Pull Request

To demonstrate PR validation (Oppgave 1 and 2):

1. Create a new branch:
   ```bash
   git checkout -b test-pr
   ```

2. Make a small change (e.g., update a README)

3. Commit and push:
   ```bash
   git add .
   git commit -m "test: trigger PR workflows"
   git push origin test-pr
   ```

4. Create PR on GitHub

5. Verify workflows run validation only (no deploy)

6. Take screenshot of PR checks

7. You can merge or close the PR after documentation

### Step 10: Final Git Commit

```bash
# Make sure you're on main branch
git checkout main

# Add all changes
git add .

# Commit everything
git commit -m "feat: complete PGR301 exam solution

- Terraform S3 infrastructure with lifecycle policies
- SAM application with CI/CD pipeline  
- Docker containerization with multi-stage build
- Custom CloudWatch metrics and dashboard
- DevOps principles essay
"

# Push to GitHub
git push origin main
```

### Step 11: Create Submission Document

Create a PDF or text file containing ONLY:

```
PGR301 Eksamen 2025
Kandidatnummer: 26
Repository: https://github.com/YOUR-USERNAME/YOUR-REPO
```

Upload this to Wiseflow.

---

## 📸 Required Screenshots

Make sure README_SVAR.md includes these screenshots:

### Oppgave 1:
- [ ] Successful Terraform workflow run (GitHub Actions)
- [ ] S3 bucket in AWS Console (optional)

### Oppgave 2:
- [ ] Successful SAM deploy workflow
- [ ] PR with validation-only workflow
- [ ] API Gateway working (curl output or Postman)

### Oppgave 3:
- [ ] Successful Docker build workflow
- [ ] Docker Hub repository showing pushed image

### Oppgave 4:
- [ ] CloudWatch Metrics showing your custom metrics
- [ ] CloudWatch Dashboard with data
- [ ] Alarm in ALARM state
- [ ] SNS email notification in inbox

---

## 🚨 Common Issues and Solutions

### Issue: Terraform backend access denied
**Solution**: Make sure you have access to `pgr301-terraform-state` bucket. If not, remove the backend block temporarily:
```hcl
# Comment out the backend in main.tf
# backend "s3" { ... }
```

### Issue: SAM deploy fails with bucket error
**Solution**: The S3 bucket needs to exist first. Deploy Oppgave 1 (Terraform) before Oppgave 2.

### Issue: Docker workflow fails with permission denied
**Solution**: Check Docker Hub credentials in GitHub Secrets. Username should be lowercase.

### Issue: CloudWatch shows no metrics
**Solution**: 
1. Verify namespace is "kandidat26" in MetricsConfig.java
2. Run the application and make API requests
3. Wait 5-10 minutes for metrics to appear
4. Check CloudWatch → Metrics → All metrics → kandidat26

### Issue: SNS email not received
**Solution**: Check spam folder. Wait a few minutes. Verify email address in terraform.tfvars.

---

## ✨ Quick Verification Commands

Check everything is ready:

```bash
# Check files exist
ls infra-s3/main.tf
ls infra-cloudwatch/main.tf
ls sentiment-docker/Dockerfile
ls .github/workflows/*.yml

# Check candidate number is updated
grep -r "kandidat-26" infra-s3/
grep "kandidat26" sentiment-docker/src/main/java/com/aialpha/sentiment/config/MetricsConfig.java

# Check all workflows
ls -la .github/workflows/

# Verify Docker builds
cd sentiment-docker && docker build -t test . && echo "✅ Docker builds successfully"
```

---

## 📝 Final Checklist

Before submitting:

- [ ] All GitHub Secrets configured (AWS + Docker Hub)
- [ ] Terraform S3 deployed and working
- [ ] SAM application deployed and tested
- [ ] Docker image built and pushed to Docker Hub
- [ ] CloudWatch metrics visible
- [ ] CloudWatch dashboard created
- [ ] Alarms tested and email received
- [ ] README_SVAR.md complete with all screenshots and links
- [ ] Essay completed (Oppgave 5)
- [ ] All code committed and pushed to main
- [ ] Repository is public (or will be before deadline)
- [ ] Submission PDF created with repository link
- [ ] Uploaded to Wiseflow

---

## 🎯 Time Estimate

- AWS Setup & Credentials: 15 min
- Terraform Deploy & Test: 20 min
- SAM Deploy & Test: 30 min
- Docker Build & Push: 20 min
- CloudWatch Setup & Screenshots: 45 min
- Documentation & Screenshots: 60 min
- **Total: ~3 hours**

---

## 💡 Tips for Success

1. **Do Oppgave 1 first** - Other tasks depend on the S3 bucket
2. **Set up all GitHub Secrets early** - Saves time later
3. **Test locally before pushing** - Catch errors faster
4. **Take screenshots immediately** - Don't wait until everything is done
5. **Keep terminal output** - Useful for troubleshooting
6. **Document as you go** - Update README_SVAR.md after each task

---

## 🆘 Need Help?

If you encounter issues:
1. Check the README.md in each directory
2. Review error messages carefully
3. Verify credentials and permissions
4. Check that candidate number (26) is used consistently
5. Ensure S3 bucket exists before deploying other services

Good luck! 🚀
