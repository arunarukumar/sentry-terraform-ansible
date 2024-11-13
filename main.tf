provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "sentry_sg" {
  name_prefix = "sentry-sg"
  description = "Security group for Sentry instance with SSH, HTTP, and HTTPS access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sentry" {
  ami           = "ami-0dee22c13ea7a9a67"
  instance_type = "t3a.xlarge"
  key_name      = "task_altair"
  
  associate_public_ip_address = true
  
  vpc_security_group_ids = [aws_security_group.sentry_sg.id]

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "SentryInstance"
  }
}

output "instance_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.sentry.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.sentry.id
}
