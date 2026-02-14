# Terraform configuration for LawPoint deployment on AWS

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "lawpoint_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "lawpoint-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lawpoint_igw" {
  vpc_id = aws_vpc.lawpoint_vpc.id

  tags = {
    Name = "lawpoint-igw"
  }
}

# Public Subnet
resource "aws_subnet" "lawpoint_public_subnet" {
  vpc_id                  = aws_vpc.lawpoint_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "lawpoint-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "lawpoint_public_rt" {
  vpc_id = aws_vpc.lawpoint_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lawpoint_igw.id
  }

  tags = {
    Name = "lawpoint-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "lawpoint_public_rta" {
  subnet_id      = aws_subnet.lawpoint_public_subnet.id
  route_table_id = aws_route_table.lawpoint_public_rt.id
}

# Security Group
resource "aws_security_group" "lawpoint_sg" {
  name        = "lawpoint-security-group"
  description = "Security group for LawPoint application"
  vpc_id      = aws_vpc.lawpoint_vpc.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend (port 3000)
  ingress {
    description = "Frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend (port 4000)
  ingress {
    description = "Backend API"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins (port 8080)
  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lawpoint-sg"
  }
}

# EC2 Instance
resource "aws_instance" "lawpoint_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.lawpoint_public_subnet.id
  vpc_security_group_ids = [aws_security_group.lawpoint_sg.id]
  key_name               = var.key_name

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    docker_compose_version = "2.24.0"
  }))

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "lawpoint-server"
  }

  depends_on = [aws_internet_gateway.lawpoint_igw]
}

# Elastic IP
resource "aws_eip" "lawpoint_eip" {
  instance = aws_instance.lawpoint_server.id
  domain   = "vpc"

  tags = {
    Name = "lawpoint-eip"
  }

  depends_on = [aws_internet_gateway.lawpoint_igw]
}
