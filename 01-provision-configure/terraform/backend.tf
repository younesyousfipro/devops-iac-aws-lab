terraform {
  # Values copied from the 00-bootstrap output: a backend block cannot read variables as it is created first
  backend "s3" {
    bucket       = "devops-iac-aws-lab-tfstate-271802700738"
    key          = "01-provision-configure/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }
}
