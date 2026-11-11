provider "aws" {
  region = "eu-north-1"

  # Same tags as 00-bootstrap: after each destroy, search Project = devops-iac-aws-lab
  # in Resource Groups & Tag Editor, anything left is a forgotten cost.
  default_tags {
    tags = {
      Project   = "devops-iac-aws-lab"
      ManagedBy = "terraform"
      Component = "provision-configure"
    }
  }
}
