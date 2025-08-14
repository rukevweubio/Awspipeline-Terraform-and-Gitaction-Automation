resource "aws_vpc" "main_vpc" {
cidr_block = var.vpc_cidr
enable_dns_hostnames = true
enable_dns_support = true
tags = {
  name="my_main_vpc"
}
  
}

resource "aws_subnet" "my_public_subnet" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = var.public_subnet_cidr
map_public_ip_on_launch = true
availability_zone = "us-east-1a"
tags={
name="${var.app-name}-my_public_subnet"}
  
}

resource "aws_subnet" "my_public_subnet2" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = true
availability_zone = "us-east-1b"
tags={
name= "${var.app-name}-my_public_subnet2"

  
}
    }
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags={
  name= "${var.app-name}-my_internet_gateway"
  }

}


resource "aws_route_table" "my_route_table" {
vpc_id = aws_vpc.main_vpc.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway
  }
  tags = {
    Name = "${var.app-name}-my_route_table"
  }
}
  
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.app-name}-sg"
  description = "Allow HTTP traffic to ECS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app-name}-sg"
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-artifacts-${var.aws-region}-${random_id.unique.hex}"
}


# Store GitHub Token in Secrets Manager
resource "aws_secretsmanager_secret" "github_token" {
  name        = "github-oauth-token"
  description = "GitHub OAuth token for CodePipeline"
}

resource "aws_secretsmanager_secret_version" "github_token_value" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = var.github_oauth_token  # You set this via TF var
}
