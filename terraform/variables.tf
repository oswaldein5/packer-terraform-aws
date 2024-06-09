#* Definition of variables in the global context

variable "num_instances" {
  description = "Number of instances (WebApp) to create (1 or 2)"
  type        = number
  default     = 2
}

variable "virginia_cidr" {
  description = "Network segment to be used in the Virginia region VPC (us-east-1)"
  type        = string
}

variable "public_subnets_cidr" {
  description = "Network segment to use for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "Network segment to use for private subnets"
  type        = list(string)
}

variable "private_domain" {
  description = "Private domain to be used for name resolution (DNS)"
  type        = string
}

variable "tags" {
  description = "Project tags"
  type        = map(string)
}
