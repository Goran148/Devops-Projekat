output "public_ip" {
  value       = aws_instance.Projekat-web.public_ip
  description = "The public IP address of the web server instance"
}

output "ssh_command" {
  value       = "ssh -i ~/Downloads/${var.ssh_key_name} ubuntu@${aws_instance.Projekat-web.public_ip}"
  description = "Command to SSH into the web server instance"
}

output "api_url" {
  value       = "http://${aws_instance.Projekat-web.public_ip}:5000"
  description = "URL to access the Python application"
}

output "eip" {
  value       = aws_eip.projekat_eip.public_ip
  description = "The Elastic IP address associated with the web server instance"
}