# An input of this folder, used in the code as var.admin_cidr: the only IP allowed to SSH.
# Value set in terraform.tfvars (git-ignored: a personal IP does not belong in a public repo)
# https://developer.hashicorp.com/terraform/language/block/variable
variable "admin_cidr" {
  description = "Public IP allowed to SSH, in CIDR form (e.g. 203.0.113.10/32). Get it with: curl -s https://checkip.amazonaws.com"
  type        = string
}
