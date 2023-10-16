locals {
  name = "petclinic"
}
module "vpc" {
  source       = "./module/vpc"
  vpc-cidr     = var.vpc_cidr
  pubsub1      = var.pubsub1
  pubsub2      = var.pubsub2
  prvsub1      = var.prvsub1
  prvsub2      = var.prvsub2
  az1          = var.az1
  az2          = var.az2
  allow_all_IP = var.allow_all_IP
}

module "keypair" {
  source = "./module/keypair"
}

module "sonarqube-server" {
  source        = "./module/sonarqube"
  ami           = var.ami-ubuntu
  instance-type = var.instance_type2
  subnet-id     = module.vpc.pubsub1
  sonarqube-sg  = module.vpc.sonarqube-SG-ID
  keypair       = module.keypair.out-pub-key
}

module "bastion" {
  source          = "./module/bastion-host"
  ami             = var.ami-redhat
  instance-type   = var.instance_type
  bastion-SG      = module.vpc.bastion-SG-ID
  keypair         = module.keypair.out-pub-key
  subnet-id       = module.vpc.pubsub2
  private-keypair = module.keypair.out-priv-key
}

module "nexus" {
  source                = "./module/nexus"
  ami                   = var.ami-redhat
  instance-type         = var.instance_type2
  keypair               = module.keypair.out-pub-key
  nexus-SG              = module.vpc.nexus-SG-ID
  subnet-id             = module.vpc.pubsub1
  newrelic-acct-id      = var.newrelic-id
  newrelic-user-licence = var.newrelic-license-key
}

module "jenkins" {
  source                = "./module/jenkins"
  ami                   = var.ami-redhat
  instance-type         = var.instance_type2
  keypair               = module.keypair.out-pub-key
  jenkins-SG            = module.vpc.jenkins-SG-ID
  subnet-id             = module.vpc.prvsub1
  subnets-id            = module.vpc.pubsubs1-2-id
  nexus-ip              = module.nexus.nexus-ip
  newrelic-acct-id      = var.newrelic-id
  newrelic-user-licence = var.newrelic-license-key
}

module "ansible" {
  source                = "./module/ansible"
  ami                   = var.ami-redhat
  instance-type         = var.instance_type2
  keypair               = module.keypair.out-pub-key
  ansible-SG-ID         = module.vpc.ansible-SG-ID
  subnet-id             = module.vpc.pubsub2
  prod-bashscript       = "${path.root}/module/ansible/prod-bashscript.sh"
  prod-playbook         = "${path.root}/module/ansible/prod-playbook.yml"
  prod-trigger          = "${path.root}/module/ansible/prod-trigger.yml"
  stage-bashscript      = "${path.root}/module/ansible/stage-bashscript.sh"
  stage-playbook        = "${path.root}/module/ansible/stage-playbook.yml"
  stage-trigger         = "${path.root}/module/ansible/stage-trigger.yml"
  password              = "${path.root}/module/ansible/password.yml"
  pri-keypair = module.keypair.out-priv-key
  nexus-ip              = module.nexus.nexus-ip
  newrelic-acct-id      = var.newrelic-id
  newrelic-user-licence = var.newrelic-license-key
}

module "docker-prod-lb" {
  source          = "./module/docker-prod-lb"
  prod-lb-SG      = module.vpc.docker-SG
  certificate-arn = module.acm.petclinic-cert
  vpc-id          = module.vpc.vpc-id
  subnets         = module.vpc.pubsubs1-2-id

}

module "docker-stage-lb" {
  source          = "./module/docker-stage-lb"
  stage-lb-SG     = module.vpc.docker-SG
  certificate-arn = module.acm.petclinic-cert
  vpc-id          = module.vpc.vpc-id
  subnets         = module.vpc.pubsubs1-2-id
}

# module "multi_az_rds" {
#   source      = "./module/rds"
#   prv-subnets = [module.vpc.prvsub1, module.vpc.prvsub1]
#   username    = data.vault_generic_secret.database.data["username"]
#   password    = data.vault_generic_secret.database.data["password"]
#   RDS-SG-ID   = [module.vpc.rds-SG-ID]
#   identifier  = var.identifier
#   db-name     = var.db-name
# }

module "route53" {
  source              = "./module/route53"
  domain-name         = var.domain
  domain-name-stage   = var.domain-stage
  stage-lb-dns-name   = module.docker-stage-lb.stage-lb-dns
  stage-lb-zone-id    = module.docker-stage-lb.stage-zone-id
  domain-name-prod    = var.domain-prod
  prod-lb-dns-name    = module.docker-prod-lb.prod-lb-dns
  prod-lb-zone-id     = module.docker-prod-lb.prod-zone-id
  jenkins-lb-dns-name = module.jenkins.jenkins-dns
  jenkins-lb-zone-id  = module.jenkins.jenkins-zone-id
  domain-name-jenkins = var.domain-jenkins
}

module "acm" {
  source  = "./module/acm"
  domain  = var.domain
  domain2 = var.domain2
}

module "stage-asg" {
  source                = "./module/stage-asg"
  ami                   = var.ami-redhat
  instance-type         = var.instance_type2
  stage-SG-ID           = module.vpc.docker-SG
  keypair               = module.keypair.out-pub-key
  stage-asg-name        = "${local.name}-stage-asg"
  vpc-zone-identifier   = [module.vpc.prvsub1, module.vpc.prvsub1]
  tg-arn                = module.docker-stage-lb.stage-tg-arn
  asg-policy            = "${local.name}-asg-policy"
  nexus-ip              = module.nexus.nexus-ip
  newrelic-acct-id      = var.newrelic-id
  newrelic-user-licence = var.newrelic-license-key
}

module "prod-asg" {
  source                = "./module/prod-asg"
  ami                   = var.ami-redhat
  instance-type         = var.instance_type2
  prod-SG-ID            = module.vpc.docker-SG
  keypair               = module.keypair.out-pub-key
  prod-asg-name         = "${local.name}-prod-asg"
  vpc-zone-identifier   = [module.vpc.prvsub1, module.vpc.prvsub1]
  tg-arn                = module.docker-prod-lb.prod-tg-arn
  asg-policy            = "${local.name}-asg-policy"
  nexus-ip              = module.nexus.nexus-ip
  newrelic-acct-id      = var.newrelic-id
  newrelic-user-licence = var.newrelic-license-key
}