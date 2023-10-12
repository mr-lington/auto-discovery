# Created Application Load balancer
resource "aws_lb" "stage-lb" {
  name               = "stage-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.stage-lb-SG]
  subnets            = var.subnets
  enable_deletion_protection = false
  tags = {
  Name = "stage-alb" 
  }
}

# Created Load balancer Listener for http
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn      = aws_lb.stage-lb.arn
  port                   = "80"
  protocol               = "HTTP"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.stage_target_group.arn
    }
}

# Creating a Load balancer Listener for https access
resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn      = aws_lb.stage-lb.arn
  port                   = "443"
  protocol               = "HTTPS"
  ssl_policy             = "ELBSecurityPolicy-2016-08"
  certificate_arn        = var.certificate-arn
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.stage_target_group.arn
  }
}

# Creating Target Group
resource "aws_lb_target_group" "stage_target_group" {
  name_prefix      = "tg-lb"
  port             = 8080
  protocol         = "HTTP"
  vpc_id           = var.vpc-id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}