#* Definition of variables

variable "id_vpc" {}                 # ID assigned to VPC
variable "privates_ip_ec2_webapp" {} # Private IP assigned to each WebApp instance
variable "private_ip_ec2_mongodb" {} # Private IP assigned to MongoDB instance
variable "private_domain" {}         # Private domain to be used for name resolution (DNS)
variable "sufix" {}                  # Project tags added to the Name tags of each resource
