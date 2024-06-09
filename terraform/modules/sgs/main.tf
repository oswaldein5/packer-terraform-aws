#* Module for the creation of all the necessary resources for the Security Groups

#* Resource to create a security group for Application Load Balancer (ALB)
resource "aws_security_group" "sg_alb" {
  name        = "sg_alb"
  vpc_id      = var.id_vpc
  description = "ALB Security Group"

  tags = {
    Name = "sg-alb-${var.sufix}"
  }
}

#* Inbound rule to allow incoming traffic from the Internet to port 80 on the ALB
resource "aws_security_group_rule" "ingress_alb_traffic" {
  security_group_id = aws_security_group.sg_alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Ingress HTTP"
}

#* Outbound rule to allow HTTP traffic to WebApp instance
resource "aws_security_group_rule" "egress_alb_traffic" {
  security_group_id        = aws_security_group.sg_alb.id
  source_security_group_id = aws_security_group.sg_webapp.id
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Egress HTTP"
}

#* Resource to create a security group for EC2 instance (WebApp)
resource "aws_security_group" "sg_webapp" {
  name        = "sg_webapp"
  vpc_id      = var.id_vpc
  description = "WebApps Security Group"

  tags = {
    Name = "sg-webapp-${var.sufix}"
  }
}

#* Inbound rule to allow ICMP traffic from VPC (10.0.0.0.0/16)
resource "aws_security_group_rule" "sgr_webapp_ingress_icmp" {
  security_group_id = aws_security_group.sg_webapp.id
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress ICMP"
}

#* Inbound rule to allow incoming SSH traffic from Bastion instance
resource "aws_security_group_rule" "sgr_webapp_ingress_ssh" {
  security_group_id        = aws_security_group.sg_webapp.id
  source_security_group_id = aws_security_group.sg_bastion.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "Ingress SSH"
}

#* Inbound rule to allow incoming HTTP traffic from the ALB
resource "aws_security_group_rule" "sgr_webapp_ingress_http" {
  security_group_id        = aws_security_group.sg_webapp.id
  source_security_group_id = aws_security_group.sg_alb.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Ingress HTTP desde ALB"
}

#* Outbound rule to allow ICMP traffic from VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_webapp_egress_icmp" {
  security_group_id = aws_security_group.sg_webapp.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}

#* Outbound rule to allow tcp/27017 traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_webapp_egress_db" {
  security_group_id = aws_security_group.sg_webapp.id
  type              = "egress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress tcp/27017"
}

#* Resource to create a security group for EC2 instance (MongoDB)
resource "aws_security_group" "sg_mongodb" {
  name        = "sg_mongodb"
  vpc_id      = var.id_vpc
  description = "MongoDB Security Group"

  tags = {
    Name = "sg-mongodb-${var.sufix}"
  }
}

#* Inbound rule to allow ICMP traffic from VPC (10.0.0.0.0/16)
resource "aws_security_group_rule" "sgr_mongodb_ingress_icmp" {
  security_group_id = aws_security_group.sg_mongodb.id
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress ICMP"
}

#* Inbound rule to allow incoming SSH traffic from Bastion instance
resource "aws_security_group_rule" "sgr_mongodb_ingress_ssh" {
  security_group_id        = aws_security_group.sg_mongodb.id
  source_security_group_id = aws_security_group.sg_bastion.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "Ingress SSH"
}

#* Inbound rule to allow tcp/27017 traffic from VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_mongodb_ingress_db" {
  security_group_id = aws_security_group.sg_mongodb.id
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress tcp/27017"
}

#* Outbound rule to allow ICMP traffic from VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_mongodb_egress_icmp" {
  security_group_id = aws_security_group.sg_mongodb.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}

#* Resource to create a security group for EC2 instance (Bastion)
resource "aws_security_group" "sg_bastion" {
  name        = "sg_bastion"
  vpc_id      = var.id_vpc
  description = "Bastion Security Group"

  tags = {
    Name = "sg-bastion-${var.sufix}"
  }
}

#* Inbound rule to allow SSH traffic from a public IP
resource "aws_security_group_rule" "sgr_bastion_ingress_ssh" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Public IPs of the Administrators
  description       = "Ingress SSH"
}

#* Outbound rule to allow SSH traffic from VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_bastion_egress_ssh" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress SSH"
}

#* Outbound rule to allow ICMP traffic from VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_bastion_egress_icmp" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}
