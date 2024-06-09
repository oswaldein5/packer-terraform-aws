// Definition of variables

variable "instance_type" {
  description = "AWS Instance Type"
  default     = "t2.micro"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ssh_username" {
  description = "Default user"
  default     = "ubuntu"
}

variable "mongo_pwd" {
  description = "Default password for MongoDB"
  type = string
}

variable "tags" {
  description = "Image tags"
  default = {
    "region"      = "US East"
    "env"         = "Dev"
    "contributor" = "Oswaldo Solano"
    "builder"     = "Packer"
    "builder-v"   = "1.10.3"
  }
}
