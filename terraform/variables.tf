variable "region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "eu-central-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the web server"
  default     = "t3.micro"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH key pair to use for the EC2 instance"
  default     = "moj-devops-kljuc"
}