#* Outputs definition

#* ID assigned to VPC
output "id_vpc" {
  value = aws_vpc.vpc_main.id
}

#* Id of the public IP assigned in the availability zone us-east-1a (NAT)
output "id_public_us_east_1a" {
  value = aws_subnet.public_us_east_1a.id
}

#* Id of the public IP assigned in the availability zone us-east-1b (Bastion)
output "id_public_us_east_1b" {
  value = aws_subnet.public_us_east_1b.id
}

#* Id of the private IP assigned in the availability zone us-east-1a (WebApp-1)
output "id_private_us_east_1a" {
  value = aws_subnet.private_us_east_1a.id
}

#* Id of the private IP assigned in the availability zone us-east-1b (WebApp-2)
output "id_private_us_east_1b" {
  value = aws_subnet.private_us_east_1b.id
}

#* Id of the private IP assigned in the availability zone us-east-1c (MongoDB)
output "id_private_us_east_1c" {
  value = aws_subnet.private_us_east_1c.id
}
