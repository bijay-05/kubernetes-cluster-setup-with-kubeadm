output "vpc_id" {
  value = aws_vpc.bookapp_vpc.id
  description = "The ID of bookapp-VPC"
}

output "public_subnets_id" {
  value = [aws_subnet.bookapp_public_subnet_A.id, aws_subnet.bookapp_public_subnet_B.id]
  description = "List of public Subnets Id"
}

output "private_subnets_id" {
  value = [aws_subnet.bookapp_private_subnet_A.id, aws_subnet.bookapp_private_subnet_B.id]
  description = "List of Private Subnets Id"
}

output "database_subnets_id" {
  value = [aws_subnet.bookapp_database_subnet_A.id, aws_subnet.bookapp_database_subnet_B.id]
  description = "List of Database Subnets Id"
}