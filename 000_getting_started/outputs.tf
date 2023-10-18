output "instance_public_ip_address" {
  value = aws_instance.my_server.public_ip
}

output "instance_private_ip_address" {
  value = aws_instance.my_server.private_ip
}