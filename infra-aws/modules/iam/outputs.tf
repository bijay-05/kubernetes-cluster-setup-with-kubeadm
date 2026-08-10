output "ssm_instance_profile_name" {
  type = string
  value = aws_iam_instance_profile.ssm_instance_profile.name
}