# Reads which AWS account Terraform is logged into, without creating anything. The account
# ID makes the bucket name unique: S3 bucket names are shared by all AWS accounts.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

# The S3 bucket (a storage container for files) that holds the Terraform state of every
# exercise, one file per folder.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "state" {
  bucket = "devops-iac-aws-lab-tfstate-${data.aws_caller_identity.current.account_id}"

  # Every session ends with terraform destroy: this stops it from deleting all states
  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
  lifecycle {
    prevent_destroy = true
  }
}

# Keeps every previous version of each state file: after a bad apply, an older state can
# be restored.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Blocks any public access to the bucket, even if a policy or an ACL later tries to open
# it: a state holds sensitive data in clear.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
