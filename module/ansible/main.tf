# Create Ansible Server
resource "aws_instance" "ansible-server" {
  ami                         = var.ami
  instance_type               = var.instance-type
  vpc_security_group_ids      = [var.ansible-SG-ID]
  subnet_id                   = var.subnet-id
  associate_public_ip_address = true
  key_name                    = var.keypair
  user_data                   = local.ansible_user_data
  tags = {
    Name = "ansible"
  }
}