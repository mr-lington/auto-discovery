resource "aws_instance" "jenkins-server" {
  ami                               = var.ami
  instance_type                     = var.instance-type
  key_name                          = var.keypair
  vpc_security_group_ids            = [var.jenkins-SG]
  subnet_id                         = var.subnet-id
  user_data                         = local.jenkins_user_data
  tags = {
    Name = "jenkins-server"
  }
}

# Create a jenkins load balancer
resource "aws_elb" "lb" {
  name               = "jenkins-alb"
  subnets = var.subnets-id
  security_groups = [var.jenkins-SG]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # listener {
  #   instance_port      = 8000
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = [aws_instance.jenkins-server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "jenkins-alb"
  }
}