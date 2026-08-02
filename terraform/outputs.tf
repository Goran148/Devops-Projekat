output "public_ip" {
  value       = aws_instance.Projekat-web.public_ip
  description = "The public IP address of the web server instance"
}

output "vpc_id" {
  value       = aws_vpc.default.id
  description = "The ID of the VPC"
}

output "subnet_id" {
  value       = aws_subnet.default.id
  description = "The ID of the subnet"
}

output "security_group_id" {
  value       = aws_security_group.default.id
  description = "The ID of the security group"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.default.id
  description = "The ID of the internet gateway"
}

output "route_table_id" {
  value       = aws_route_table.default.id
  description = "The ID of the route table"
}