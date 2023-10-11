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