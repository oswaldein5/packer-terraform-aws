#* Definition of variables

variable "id_vpc" {}                # ID assigned to VPC
variable "id_security_group_alb" {} # ID of the security group assigned for the ALB
variable "ids_public_us_east" {}    # ID assigned to each public IP
variable "ids_ec2_webapp" {}        # ID assigned to each WebApp instance
variable "sufix" {}                 # Project tags added to the Name tags of each resource
