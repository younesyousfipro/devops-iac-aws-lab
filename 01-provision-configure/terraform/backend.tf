# The backend is where Terraform stores its state: the record of what it created, used to
# compare the code with reality. Here the state is a file in the 00-bootstrap bucket, not on
# the laptop, so it survives the laptop and can be shared.
# https://developer.hashicorp.com/terraform/language/backend
terraform {
  # Values copied from the 00-bootstrap output: a backend block cannot read variables
  # https://developer.hashicorp.com/terraform/language/backend/s3
  backend "s3" {
    bucket = "devops-iac-aws-lab-tfstate-271802700738"
    key    = "01-provision-configure/terraform.tfstate" # path in the bucket, one per exercise
    region = "eu-north-1"
    # During an apply, a lock file next to the state refuses a second simultaneous apply
    use_lockfile = true
  }
}
