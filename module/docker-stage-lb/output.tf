output "stage-tg-arn" {
 value = aws_lb_target_group.stage_target_group.arn
}

output "stage-lb-dns" {
 value = aws_lb.stage-lb.dns_name
}
output "stage-zone-id" {
 value = aws_lb.stage-lb.zone_id
}