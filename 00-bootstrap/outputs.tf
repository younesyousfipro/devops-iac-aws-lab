# A value this folder hands back after apply, read with terraform output: the bucket name,
# to copy into the backend of each exercise.
# https://developer.hashicorp.com/terraform/language/block/output
output "state_bucket_name" {
  value = aws_s3_bucket.state.bucket
}
