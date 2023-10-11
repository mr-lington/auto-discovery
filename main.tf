locals {
  name = "petclinic"
}
module "vpc" {
  source                 = "./module/vpc"
  vpc-cidr = var.vpc_cidr
  pubsub1 = var.pubsub1
  pubsub2 = var.pubsub2
  prvsub1 = var.prvsub1
  prvsub2 = var.prvsub2
  az1 = var.az1
  az2 = var.az2
  allow_all_IP = var.allow_all_IP
  }

module "keypair" {
  source                 = "./module/keypair"
  }

  module "sonarqube-server" {
  source                 = "./module/sonarqube"
  ami = var.ami-ubuntu
  instance-type= var.instance_type2
  subnet-id= module.vpc.pubsub1
  sonarqube-sg= module.vpc.sonarqube-SG-ID
  keypair= module.keypair.out-pub-key
  }

  module "bastion" {
  source                 = "./module/bastion-host"
  ami = var.ami-redhat
  instance-type = var.instance_type
  bastion-SG = module.vpc.bastion-SG-ID
  keypair = module.keypair.out-pub-key
  subnet-id = module.vpc.pubsub2
  private-keypair = module.keypair.out-priv-key
  }

module "nexus" {
source                 = "./module/nexus"
ami = var.ami-redhat
instance-type = var.instance_type2
keypair = module.keypair.out-pub-key
nexus-SG = module.vpc.nexus-SG-ID
subnet-id = module.vpc.pubsub1
newrelic-acct-id = var.newrelic-id
newrelic-user-licence = var.newrelic-license-key
}

module "jenkins" {
  source                 = "./module/jenkins"
  ami = var.ami-redhat
  instance-type= var.instance_type2
  keypair = module.keypair.out-pub-key
  jenkins-SG= module.vpc.jenkins-SG-ID
  subnet-id= module.vpc.prvsub1
  subnet = [module.vpc.pubsub1]
  nexus-ip= module.nexus.nexus-ip
  newrelic-acct-id= var.newrelic-id
  newrelic-user-licence= var.newrelic-license-key
  }

  module "ansible" {
  source                 = "./module/ansible"
  ami = var.ami-redhat
  instance-type= var.instance_type2
  keypair = module.keypair.out-pub-key
  ansible-SG-ID= module.vpc.ansible-SG-ID
  subnet-id= module.vpc.pubsub2
  newrelic-acct-id= var.newrelic-id
  newrelic-user-licence= var.newrelic-license-key
  }