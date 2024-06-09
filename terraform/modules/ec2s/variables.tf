#* Definition of variables

variable "num_instances" {}             # Number of instances (WebApp) to create (1 or 2)
variable "id_public_bastion" {}         # Id of the public IP assigned in the availability zone us-east-1b (Bastion)
variable "ids_private_us_east" {}       # ID assigned to the private IP of each instance (WebApps, MongoDB)
variable "id_security_group_webapp" {}  # ID of the security group assigned for WebApp instances
variable "id_security_group_mongodb" {} # ID of the security group assigned for the MongoDB instance
variable "id_security_group_bastion" {} # ID of the security group assigned for the Bastion instance
variable "sufix" {}                     # Project tags added to the Name tags of each resource
