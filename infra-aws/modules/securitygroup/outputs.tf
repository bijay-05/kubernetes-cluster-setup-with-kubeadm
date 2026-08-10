output "instance_ssh_sg_id" {
  type = string
  value = aws_security_group.instance_ssh_sg.id
}

output "vpc_internal_sg_id" {
  type = string
  value = aws_security_group.vpc_internal_sg.id
}