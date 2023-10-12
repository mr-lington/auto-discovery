output "prod_target-group" {
 value = aws_lb_target_group.prod_target-group.arn
}

output "prod-lb-dns" {
 value = aws_lb.prod-lb.dns_name
}
output "prod-zone-id" {
 value = aws_lb.prod-lb.zone_id
}