# Settings for Terraform itself, not for AWS: which versions may run this folder, so that
# every machine gets the same behavior.
# https://developer.hashicorp.com/terraform/language/block/terraform
terraform {
  # Terraform CLI version: ~> 1.17 accepts 1.17 and any later 1.x, never 2.0
  # https://developer.hashicorp.com/terraform/language/expressions/version-constraints
  required_version = "~> 1.17"

  # Plugins downloaded by terraform init. The AWS provider is the translator that turns each
  # resource of this folder into AWS API calls. ~> 6.72 accepts any later 6.x, never 7.0;
  # the exact version is pinned in .terraform.lock.hcl
  # https://developer.hashicorp.com/terraform/language/files/dependency-lock
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.72"
    }
  }
}
