# Create keypair with Terraform
resource "tls_private_key" "lington_Key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "lington_Key_priv" {
  filename        = "lington_key.pem"
  content         = tls_private_key.lington_Key.private_key_pem
  file_permission = "600"
}

resource "aws_key_pair" "lington_Key_pub" {
  key_name   = "lington_key"
  public_key = tls_private_key.lington_Key.public_key_openssh
}