output "server_public_ip" {
  description = ""
  value       = aws_instance.my_server.public_ip
}

output "security_group_id" {
  description = ""
  value       = aws_security_group.practice_sg.id
}