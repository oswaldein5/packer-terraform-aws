#* Module for the creation of all the necessary resources for the Application Load Balancer (ALB)

#* Resource definition for an Application Load Balancer (ALB)
resource "aws_lb" "app_load_balancer" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.id_security_group_alb]
  subnets            = var.ids_public_us_east

  tags = {
    Name = "app-load-balancer-${var.sufix}"
  }
}

#* Resource definition for an ALB target group
resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.id_vpc

  tags = {
    Name = "alb-target-group-${var.sufix}"
  }
}

#* Resource definition for an ALB listener
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  tags = {
    Name = "alb-listener-http-${var.sufix}"
  }
}

#* Define resources for dynamically attaching ALB target instances
resource "aws_lb_target_group_attachment" "tg_attachment_ec2s" {
  for_each         = var.ids_ec2_webapp
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = each.value
  port             = 80
}
