# AI Studio: minimal GKE Terraform

Creates a **billable** single-zone public-control-plane GKE Standard sandbox, one CPU worker, VPC/subnet, Artifact Registry and a dedicated backend service account authorized for Vertex AI through GKE Workload Identity Federation. **It does not deploy the website or enable HTTPS.**

## Prerequisites
- Billing-enabled Google Cloud project and Terraform >=1.6.
- gcloud authentication with permissions to enable APIs and manage networking, GKE, service accounts and IAM.
- Run `bootstrap/README.md` once to create a versioned GCS state bucket.

## Deploy (Cloud Shell or local workstation)
```bash
cp example.tfvars terraform.tfvars
# Edit project_id in terraform.tfvars.
gcloud auth application-default login  # Cloud Shell may already have ADC
terraform init -backend-config="bucket=YOUR_STATE_BUCKET" -backend-config="prefix=ai-studio/gke"
terraform fmt -check
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
terraform output get_credentials
```
Run the output `get_credentials` command to configure kubectl.

## Connect the future FastAPI backend
Replace `REPLACE_BACKEND_SERVICE_ACCOUNT_EMAIL` in `kubernetes/backend-identity.yaml` with Terraform output `backend_service_account`, then apply the YAML. Configure the backend Deployment with `serviceAccountName: backend` in namespace `ai-studio`. Vertex AI calls use Application Default Credentials; never embed service-account JSON keys in the frontend.

## GitHub Actions
Do **not** store static Google service-account keys. Bootstrap GitHub OIDC Workload Identity Federation and grant a dedicated CI service account scoped Terraform deployment permissions plus state bucket object access. Add GitHub Actions after confirming a manual Terraform apply. Never put terraform.tfvars with real secrets into git.

## Costs and security
GKE management, nodes, disks, public IP/networking, storage and Vertex AI usage can incur charges. Budget alerts are not spending caps. Public-control-plane, no NAT/private-node configuration and `deletion_protection=false` are **sandbox only**. Protect production with private networking, limited API access, policy controls, least-privilege IAM and deletion protection.

## Cleanup
```bash
terraform destroy -var-file=terraform.tfvars
```
The bootstrap state bucket persists intentionally; delete only after verifying state is no longer needed.
