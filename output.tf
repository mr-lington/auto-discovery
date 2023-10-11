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
