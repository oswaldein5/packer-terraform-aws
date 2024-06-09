#* Outputs definition

#* DNS name assigned for the Application Load Balancer (ALB)
output "dns_name_alb" {
  value = aws_lb.app_load_balancer.dns_name
}
