resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Projekat-vpc"
  }
}

resource "aws_subnet" "default" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Projekat-subnet"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Projekat-igw"
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}

resource "aws_security_group" "default" {
  name        = "Projekat-sg-${var.environment}"
  description = "Security group for Projekat"
  vpc_id      = aws_vpc.default.id

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
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "Projekat-web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = "moj-devops-kljuc"
  subnet_id                   = aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.default.id]
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
