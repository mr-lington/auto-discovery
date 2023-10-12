# Creating Application Load balancer
resource "aws_lb" "prod-lb" {
  name               = "prod-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.prod-lb-SG]
  subnets            = [var.subnets]
  enable_deletion_protection = false
  tags = {
    Environment = "prod-lb"
  }
}

#Creating a Load balancer Listener for http access
resource "aws_lb_listener" "prod_lb_listener" {
  load_balancer_arn = aws_lb.prod-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_target-group.arn
  }
}

#Creating a Load balancer Listener for https access
resource "aws_lb_listener" "prod_lb_listener_https" {
  load_balancer_arn = aws_lb.prod-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate-arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_target-group.arn
  }
}

#Creating Target Group
resource "aws_lb_target_group" "prod_target-group" {
  name     = "prod-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}