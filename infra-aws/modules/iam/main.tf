resource "aws_iam_role" "test_ssm_role" {
  name = "testssm-role"
  assume_role_policy = jsonencode({
	Version = "2012-10-17",
	Statement = [
		{
		Effect = "Allow",
		Principal = {
			Service = "ec2.amazonaws.com"
		},
		Action = "sts:AssumeRole"
	},
	]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role = aws_iam_role.test_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "testssm-instance-profile"
  role = aws_iam_role.test_ssm_role.name
}