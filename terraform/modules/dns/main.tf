#* Module for the creation of all the necessary resources for Private Zine and DNS

#* Create a Route 53 private zone for the domain (lab.test) associated with the VPC
resource "aws_route53_zone" "private_zone" {
  name = var.private_domain

  vpc {
    vpc_id = var.id_vpc
  }

  tags = {
    Name = "private-zone-${var.sufix}"
  }
}

#* Create type "A" record in Route 53 for EC2 WebApp instances in the private zone
#* Dynamically generated for each instance
resource "aws_route53_record" "ec2_webapps_record" {
  for_each = var.privates_ip_ec2_webapp
  zone_id  = aws_route53_zone.private_zone.id
  name     = "webapp-${each.key + 1}.${var.private_domain}"
  type     = "A"
  ttl      = "300"
  records  = [each.value]
}

#* Create type "A" record in Route 53 for EC2 MongoDB instances in private zone
resource "aws_route53_record" "ec2_mongodb_record" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "mongodb.${var.private_domain}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_ec2_mongodb]
}
