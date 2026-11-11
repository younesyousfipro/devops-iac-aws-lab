# Provides an EC2 key pair resource. A key pair is used to control login access to EC2 instances.
# Currently this resource requires an existing user-supplied key pair.
# This key pair's public key will be registered with AWS to allow logging-in to EC2 instances.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
# pathexpand turns ~ into the home folder, file() does not: https://developer.hashicorp.com/terraform/language/functions/pathexpand
resource "aws_key_pair" "admin" {
  key_name   = "provision-configure-admin"
  public_key = file(pathexpand("~/.ssh/id_ed25519_aws.pub"))
}

# A security group is a firewall attached to an instance: it lists the traffic allowed in
# (ingress) and out (egress); everything else is blocked. Its rules are the separate
# resources below, as the docs recommend (inline ingress/egress blocks conflict with them).
# Changing the description replaces the group: AWS cannot update it.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "web" {
  name        = "provision-configure-web"
  description = "SSH from the admin IP, HTTP from anywhere"
}

# Inbound: SSH (port 22) from the admin IP only, for Ansible and manual login
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "ssh_from_admin" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = var.admin_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Inbound: HTTP (port 80) from anywhere, to open the app in a browser
resource "aws_vpc_security_group_ingress_rule" "http_from_anywhere" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Outbound: everything (apt install, updates). AWS allows it by default, but Terraform
# removes that default rule, so it is declared again here.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols and ports
}
