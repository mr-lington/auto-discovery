output "sonarqube-ip" {
  value = module.sonarqube-server.sonarqube-ip
}

output "bastion-ip" {
  value = module.bastion.bastion-ip
}

output "nexus-ip" {
  value = module.nexus.nexus-ip
}

output "ansible-ip" {
  value = module.ansible.ansible-ip
}

output "jenkins-ip" {
  value = module.jenkins.jenkins-ip
}

output "jenkins-lb-dns" {
  value = module.jenkins.jenkins-dns
}

output "prod-lb-dns" {
  value = module.docker-prod-lb.prod-lb-dns
}

output "stage-lb-dns" {
  value = module.docker-stage-lb.stage-lb-dns
}

# # output "certificate_arn" {
# #   value = module.ssl-certificate.certificate_arn
# # }

# output "route53-server" {
#   value = module.ROUTE53.route53_dns-name
# }