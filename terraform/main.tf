resource "aws_vpc" "projekat_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Projekat-vpc"
  }
}

resource "aws_subnet" "projekat_subnet" {
  vpc_id     = aws_vpc.projekat_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Projekat-subnet"
  }
}

resource "aws_internet_gateway" "projekat_igw" {
  vpc_id = aws_vpc.projekat_vpc.id

  tags = {
    Name = "Projekat-igw"
  }
}

resource "aws_route_table" "projekat_route_table" {
  vpc_id = aws_vpc.projekat_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.projekat_igw.id
  }

  tags = {
    Name = "Projekat-route-table"
  }
}

resource "aws_route_table_association" "projekat_route_table_association" {
  subnet_id      = aws_subnet.projekat_subnet.id
  route_table_id = aws_route_table.projekat_route_table.id
}

resource "aws_security_group" "projekat_sg" {
  name        = "Projekat-sg-${var.environment}"
  description = "Security group for Projekat"
  vpc_id      = aws_vpc.projekat_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Python App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Projekat-sg-${var.environment}"
    environment = var.environment
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "Projekat-web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = aws_subnet.projekat_subnet.id
  vpc_security_group_ids      = [aws_security_group.projekat_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install docker.io -y
                systemctl start docker
                systemctl enable docker
                usermod -aG docker ubuntu
                EOF

  tags = {
    Name        = "Projekat-web"
    Environment = var.environment
  }
}

resource "aws_eip" "projekat_eip" {
  instance = aws_instance.Projekat-web.id
  domain   = "vpc"

  tags = {
    Name        = "Projekat-eip"
    Environment = var.environment
  }
}