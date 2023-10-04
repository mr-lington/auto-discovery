output "out-pub-key" {
  value = aws_key_pair.lington_Key_pub.key_name
}

output "out-priv-key" {
  value = tls_private_key.lington_Key.private_key_pem
}