resource "aws_key_pair" "ssh_keypair" {

  for_each = var.nodes

  key_name = "keypair-${each.value.name}"
  public_key = each.value.public_key
}

resource "aws_instance" "instance" {

  for_each = var.nodes

  subnet_id = each.value.subnet_id
  vpc_security_group_ids = var.security_groups_id

  launch_template {
    id = var.launch_template_id
    version = var.launch_template_version
  }

  key_name = "keypair-${each.value.name}"

  associate_public_ip_address = each.value.public
  iam_instance_profile = var.ssm_instance_profile_name

  instance_type = each.value.instance_type
  source_dest_check = false

  user_data = file(each.value.custom_script_path)

  # user_data = <<EOF
  # sudo yum update && sudo yum install postgresql16 -y
  # EOF
}