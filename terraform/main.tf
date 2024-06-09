#***********************************************************************************
#* Project:         MEAN stack
#* Description:     Create resources using Terraform to provision 3 ec2 instances:
#*                  2 WebApps(2) and 1 MongoDB,
#*                  Configure implementation of HTTP load balancer and 
#*                  private zone (lab.test) for name resolution (DNS).
#* Cloud Provider:  AWS
#* Author:          Oswaldo Solano
#***********************************************************************************

#* Module for the creation of all the necessary resources for the Virtual Private Cloud (VPC)
module "vpc" {
  source               = "./modules/vpc"
  virginia_cidr        = var.virginia_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  sufix                = local.sufix
}

#* Module for the creation of all the necessary resources for the Security Groups
module "security_groups" {
  source        = "./modules/sgs"
  virginia_cidr = var.virginia_cidr
  id_vpc        = module.vpc.id_vpc # output from module: vpc
  sufix         = local.sufix
}

#* Module to create EC2 Instances (WebApp, MongoDB and Bastion)
module "ec2_instances" {
  source        = "./modules/ec2s"
  num_instances = var.num_instances
  ids_private_us_east = [
    module.vpc.id_private_us_east_1a,
    module.vpc.id_private_us_east_1b,
    module.vpc.id_private_us_east_1c
  ]                                                                            # output from module: vpc
  id_public_bastion         = module.vpc.id_public_us_east_1b                  # output from module: vpc
  id_security_group_webapp  = module.security_groups.id_security_group_webapp  # output from module: security_groups
  id_security_group_mongodb = module.security_groups.id_security_group_mongodb # output from module: security_groups
  id_security_group_bastion = module.security_groups.id_security_group_bastion # output from module: security_groups
  sufix                     = local.sufix
}

#* Module for the creation of all the necessary resources for the Application Load Balancer (ALB)
module "app_load_balancer" {
  source = "./modules/alb"
  id_vpc = module.vpc.id_vpc # output from module: vpc
  ids_public_us_east = [
    module.vpc.id_public_us_east_1a,
    module.vpc.id_public_us_east_1b
  ]                                                                    # output from module: vpc
  id_security_group_alb = module.security_groups.id_security_group_alb # output from module: security_groups
  ids_ec2_webapp        = module.ec2_instances.ids_ec2_webapp          # output from module: ec2_instances
  sufix                 = local.sufix
}

#* Module for the creation of all the necessary resources for Private Zine and DNS
module "dns" {
  source                 = "./modules/dns"
  id_vpc                 = module.vpc.id_vpc                           # output from module: vpc
  privates_ip_ec2_webapp = module.ec2_instances.privates_ip_ec2_webapp # output from module: ec2_instances
  private_ip_ec2_mongodb = module.ec2_instances.private_ip_ec2_mongodb # output from module: ec2_instances
  private_domain         = var.private_domain
  sufix                  = local.sufix
}

#* Display the public IP assigned to the Bastion host
output "public_ip_bastion" {
  value = module.ec2_instances.public_ip_ec2_bastion # output from module: ec2_instances
}

#* Show the DNS name assigned for the Application Load Balancer (ALB)
output "dns_name_load_balancer" {
  value = module.app_load_balancer.dns_name_alb # output from module: app_load_balancer
}
