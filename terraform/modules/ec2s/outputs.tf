#* Outputs definition

#* ID assigned to each WebApp instance
output "ids_ec2_webapp" {
  value = {
    for instance_key, instance in aws_instance.ec2_webapps : instance_key => instance.id
  }
}

#* Private IP assigned to each WebApp instance
output "privates_ip_ec2_webapp" {
  value = {
    for instance_key, instance in aws_instance.ec2_webapps : instance_key => instance.private_ip
  }
}

#* Private IP assigned to MongoDB instance
output "private_ip_ec2_mongodb" {
  value = aws_instance.ec2_mongodb.private_ip
}

#* Public IP assigned to Bastion instance
output "public_ip_ec2_bastion" {
  value = aws_instance.ec2_bastion.public_ip
}
