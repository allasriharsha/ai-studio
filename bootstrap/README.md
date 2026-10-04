# One-time bootstrap
Run from Cloud Shell with a billing-enabled project. Requires project API enablement, IAM and storage permissions.

```bash
export PROJECT_ID="your-project-id"
export REGION="us-central1"
gcloud config set project "$PROJECT_ID"
gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com storage.googleapis.com iam.googleapis.com
export TF_BUCKET="${PROJECT_ID}-ai-studio-tfstate"
gcloud storage buckets create "gs://${TF_BUCKET}" --location="$REGION" --uniform-bucket-level-access --public-access-prevention
gcloud storage buckets update "gs://${TF_BUCKET}" --versioning
```

Bucket names are globally unique; adjust TF_BUCKET if necessary. This bootstrap runs once and the bucket is not managed by this Terraform configuration.
