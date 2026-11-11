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

# Looks up the AMI (the disk image the instance boots from) instead of hard-coding its ID:
# an AMI ID differs by region and gets outdated. Latest Ubuntu 26.04 LTS published by
# Canonical (owner 099720109477), so nobody else can slip in an image with the same name.
# Consequence: when Canonical publishes a newer image, plan shows the instance replaced.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
# Owner ID and name pattern: https://documentation.ubuntu.com/aws/aws-how-to/instances/find-ubuntu-images/
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }
}

# The virtual machine (EC2 instance) that Ansible configures: Ubuntu, reachable over SSH with
# the key pair above and protected by the security group above. Placed in the default VPC,
# whose subnets give it a public IP. t3.micro is covered by the Free plan in eu-north-1.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.admin.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "provision-configure-web" # name shown in the EC2 console
  }
}
