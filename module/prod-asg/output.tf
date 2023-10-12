output "prod-ASG-id" {
  value = aws_autoscaling_group.prod-asg.id
}

output "prod-ASG-name" {
  value = aws_autoscaling_group.prod-asg.name
}

output "prod-LT-id" {
  value = aws_launch_template.prod_lt.image_id
}