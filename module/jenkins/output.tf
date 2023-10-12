output "jenkins-ip" {
  value = aws_instance.jenkins-server.private_ip
}
output "jenkins-dns" {
  value = aws_elb.lb.dns_name
}

output "jenkins-zone-id" {
  value = aws_elb.lb.zone_id
}