#* Module to create EC2 Instances (WebApp, MongoDB and Bastion)

#* Create EC2 Instance (WebApp) using AMI image previously built with Packer
#* They are generated dynamically according to the configured parameter (var.num_instances).
resource "aws_instance" "ec2_webapps" {
  count                  = var.num_instances                     # 1 to 2 instances to create
  ami                    = data.aws_ami.packer_img_ami_webapp.id # The AMI ID is obtained from data source "packer_img_ami_webapp"
  instance_type          = "t2.micro"
  subnet_id              = var.ids_private_us_east[count.index]
  key_name               = data.aws_key_pair.key.key_name # Pre-defined key in the AWS Portal
  vpc_security_group_ids = [var.id_security_group_webapp]
  tags = {
    "Name" = "webapp-${count.index + 1}-${var.sufix}"
  }
}

#* Create EC2 Instance (MongoDB) using the AMI image previously built with Packer
resource "aws_instance" "ec2_mongodb" {
  ami                    = data.aws_ami.packer_img_ami_mongodb.id # The AMI ID is obtained from data source "packer_img_ami_mongodb"
  instance_type          = "t2.micro"
  subnet_id              = var.ids_private_us_east[2]
  key_name               = data.aws_key_pair.key.key_name # Pre-defined key in the AWS Portal
  vpc_security_group_ids = [var.id_security_group_mongodb]
  tags = {
    Name = "mongodb-${var.sufix}"
  }
}

#* Create EC2 Instance (Bastion) to check all other instances via SSH
resource "aws_instance" "ec2_bastion" {
  ami                    = "ami-00beae93a2d981137"
  instance_type          = "t2.micro"
  subnet_id              = var.id_public_bastion
  key_name               = data.aws_key_pair.key.key_name # Pre-defined key in the AWS Portal
  vpc_security_group_ids = [var.id_security_group_bastion]
  tags = {
    "Name" = "bastion-${var.sufix}"
  }
}
