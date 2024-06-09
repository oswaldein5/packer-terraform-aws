#* Outputs definition

#* Security group ID assigned for the ALB
output "id_security_group_alb" {
  value = aws_security_group.sg_alb.id
}

#* ID of the security group assigned for WebApp instances
output "id_security_group_webapp" {
  value = aws_security_group.sg_webapp.id
}

#* ID of the security group assigned for the MongoDB instance
output "id_security_group_mongodb" {
  value = aws_security_group.sg_mongodb.id
}

#* ID of the security group assigned for the Bastion instance
output "id_security_group_bastion" {
  value = aws_security_group.sg_bastion.id
}
