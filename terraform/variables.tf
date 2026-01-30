# Variables for Terraform configuration

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (Ubuntu 22.04 LTS - Free Tier eligible)"
  type        = string
  default     = "ami-0030e4319cbf4dbf2" # Ubuntu 22.04 LTS in us-east-1 (latest)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro" # Free tier eligible
}

variable "key_name" {
  description = "SSH key pair name for EC2 access"
  type        = string
  default     = "lawpoint-key"
}
