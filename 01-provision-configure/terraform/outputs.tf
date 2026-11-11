# The value this folder hands back after apply, read with terraform output: the instance's
# public IP, to write in the Ansible inventory and to open the app in a browser.
# https://developer.hashicorp.com/terraform/language/block/output
output "public_ip" {
  value = aws_instance.web.public_ip
}
