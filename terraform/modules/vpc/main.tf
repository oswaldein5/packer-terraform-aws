#* Module for the creation of all the necessary resources for the Virtual Private Cloud (VPC)

#* Recurso para crear una VPC con soporte de DNS y Hostnames
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.virginia_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.sufix}"
  }
}

#* Resource for creating a public subnet in us-east-1a
resource "aws_subnet" "public_us_east_1a" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.public_subnets_cidr[0]
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-1a-${var.sufix}"
  }
}

#* Resource for creating a public subnet in us-east-1b
resource "aws_subnet" "public_us_east_1b" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.public_subnets_cidr[1]
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-1b-${var.sufix}"
  }
}

#* Resource for creating a private subnet in us-east-1a (WepApp-1)
resource "aws_subnet" "private_us_east_1a" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnets_cidr[0]
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "private-us-east-1a-${var.sufix}"
  }
}

#* Resource for creating a private subnet in us-east-1b (WepApp-2)
resource "aws_subnet" "private_us_east_1b" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnets_cidr[1]
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "private-us-east-1b-${var.sufix}"
  }
}

#* Resource for creating a private subnet in us-east-1c (MongoDB)
resource "aws_subnet" "private_us_east_1c" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnets_cidr[2]
  availability_zone = "us-east-1c"

  tags = {
    "Name" = "private-us-east-1c-${var.sufix}"
  }
}

#* Resource to create an Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw-${var.sufix}"
  }
}

#* Resource to create a NAT Elastic IP address
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-${var.sufix}"
  }

  depends_on = [aws_internet_gateway.igw]
}

#* Resource to create a NAT gateway for the public subnet in the us-east-1a availability zone
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_us_east_1a.id

  tags = {
    Name = "nat-gateway-${var.sufix}"
  }

  depends_on = [aws_internet_gateway.igw]
}

#* Resource for creating a routing table for private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-rt-${var.sufix}"
  }
}

#* Resource for creating a routing table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-${var.sufix}"
  }
}

#* Association of the public routing table to the subnet in the us-east-1a availability zone
resource "aws_route_table_association" "public_us_east_1a" {
  subnet_id      = aws_subnet.public_us_east_1a.id
  route_table_id = aws_route_table.public_rt.id
}

#* Association of the public routing table to the subnet in the us-east-1b availability zone
resource "aws_route_table_association" "public_us_east_1b" {
  subnet_id      = aws_subnet.public_us_east_1b.id
  route_table_id = aws_route_table.public_rt.id
}

#* Association of the private routing table to the subnet in the us-east-1a availability zone
resource "aws_route_table_association" "private_us_east_1a" {
  subnet_id      = aws_subnet.private_us_east_1a.id
  route_table_id = aws_route_table.private_rt.id
}

#* Association of the private routing table to the subnet in the us-east-1b availability zone
resource "aws_route_table_association" "private_us_east_1b" {
  subnet_id      = aws_subnet.private_us_east_1b.id
  route_table_id = aws_route_table.private_rt.id
}

#* Association of the private routing table to the subnet in the us-east-1c availability zone
resource "aws_route_table_association" "private_us_east_1c" {
  subnet_id      = aws_subnet.private_us_east_1c.id
  route_table_id = aws_route_table.private_rt.id
}
