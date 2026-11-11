# 00-bootstrap — Terraform state bucket

Creates the S3 bucket that stores the Terraform state of every exercise. **Run it once per AWS account, before anything else.**

Why a separate folder: an exercise's S3 backend needs its bucket to exist before `terraform init`. A folder cannot store its state in a bucket it has not created yet, so this one keeps a **local** state (`terraform.tfstate`, git-ignored).

## What it creates

| Block | Role |
|---|---|
| `data "aws_caller_identity"` | reads the account ID, which makes the bucket name unique |
| `aws_s3_bucket` | the bucket `devops-iac-aws-lab-tfstate-<account_id>`, protected by `prevent_destroy` |
| `aws_s3_bucket_versioning` | keeps every previous version of each state, to roll back after a bad apply |
| `aws_s3_bucket_public_access_block` | blocks any public access: a state holds sensitive data in clear |

Encryption is not declared: S3 encrypts every object by default (SSE-S3).

## Usage

Prerequisites: Terraform `~> 1.17`, AWS CLI logged in with `aws login`.

```bash
terraform init
terraform plan     # expected: Plan: 3 to add
terraform apply
terraform output state_bucket_name
```

Copy the bucket name into the `backend "s3"` block of each exercise (a backend block cannot read variables).

## Lifecycle

- **Not destroyed at the end of a session**: `prevent_destroy` makes `terraform destroy` fail here on purpose. The bucket costs a few cents at most.
- **Keep the local `terraform.tfstate`**: it is the only record of the bucket for Terraform.
- **End of project**: remove the `lifecycle` block, empty the bucket (all versions), then `terraform destroy`.
