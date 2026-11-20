# The value this folder hands back after apply, read with terraform output: the instance's
# public IP, to log in over SSH and to open the app in a browser (the Ansible inventory gets
# it directly, see local_file in main.tf).
# https://developer.hashicorp.com/terraform/language/block/output
output "public_ip" {
  value = aws_instance.web.public_ip
}
