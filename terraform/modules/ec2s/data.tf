#* Obtain the key pair with name "mykey
data "aws_key_pair" "key" {
  key_name = "mykey"
}

#* Get image ID (WebApp) previously created with Packer
data "aws_ami" "packer_img_ami_webapp" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["webapp-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#* Get ID of the image (MongoDB) previously created with Packer
data "aws_ami" "packer_img_ami_mongodb" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["mongodb-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
