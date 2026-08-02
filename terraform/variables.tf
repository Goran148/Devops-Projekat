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