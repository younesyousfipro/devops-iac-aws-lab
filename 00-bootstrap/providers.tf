provider "aws" {
  region = "eu-north-1"

  # Optional. AWS has no mandatory resource group (unlike Azure): tags are the only way
  # to group and find resources. default_tags puts these tags on every resource of this
  # folder, so none can be forgotten. Used after each destroy: Resource Groups & Tag
  # Editor, search Project = devops-iac-aws-lab, anything left is a forgotten cost.
  default_tags {
    tags = {
      Project   = "devops-iac-aws-lab"
      ManagedBy = "terraform" # do not edit by hand in the console
      Component = "bootstrap" # which folder created it
    }
  }
}
