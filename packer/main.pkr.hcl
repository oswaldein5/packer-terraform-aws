/***************************************************************************************/
// Project:         MEAN stack
// Description:     Create and deploy AWS AMI images (WebApp and MongoDB) using Packer.
// Cloud Provider:  AWS
// Author:          Oswaldo Solano
/***************************************************************************************/

// Define AMI image for WebApp server
source "amazon-ebs" "webapp" {
  ami_name      = "webapp-${formatdate("DD-MMM-YYYY-hh-mm-ss", timestamp())}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = var.ssh_username
  tags = merge(var.tags, {"name" = "webapp"})
}

// Define AMI image for MongoDB server
source "amazon-ebs" "mongodb" {
  ami_name      = "mongodb-${formatdate("DD-MMM-YYYY-hh-mm-ss", timestamp())}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = var.ssh_username
  tags = merge(var.tags, {"name" = "mongodb"})
}

// Define Build configuration for WebApp server
build {
  name    = "img-packer-webapp"
  sources = ["source.amazon-ebs.webapp"]
  post-processor "manifest" {
    output = "manifest-webapp.json"
  }
  provisioner "file" {
    source = "files/"
    destination = "/tmp/"
  }
  provisioner "file" {
    source = "scripts/webapp-setup.sh"
    destination = "/tmp/"
  }
  provisioner "shell" {
    inline = [
      "sudo chmod 774 /tmp/webapp-setup.sh",
      "sudo sh /tmp/webapp-setup.sh",
    ]
  }
}

// Define Build Configuration for MongoDB Server
build {
  name    = "img-packer-mongodb"
  sources = ["source.amazon-ebs.mongodb"]
  post-processor "manifest" {
    output = "manifest-mongodb.json"
  }
  provisioner "file" {
    source = "scripts/mongodb-setup.sh"
    destination = "/tmp/"
  }
  provisioner "shell" {
    environment_vars = [
      "MONGO_PWD=${var.mongo_pwd}",
    ]
    execute_command = "sudo -S -E bash -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "chmod 774 /tmp/mongodb-setup.sh",
      "sh /tmp/mongodb-setup.sh",
    ]
  }
}
