#* Definition of variables

variable "virginia_cidr" {}        # Network segment to be used in the Virginia region VPC (us-east-1)
variable "public_subnets_cidr" {}  # Network segment to use for public subnets
variable "private_subnets_cidr" {} # Network segment to use for private subnets
variable "sufix" {}                # Project tags added to the Name tags of each resource
