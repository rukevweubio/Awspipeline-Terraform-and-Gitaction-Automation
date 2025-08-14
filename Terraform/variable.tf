variable "aws-region" {
default = "us-east-1"
  
}

variable "app-name" {
default = "my-nodejs-app"
  
}

variable "ecs-cluster-name" {
default = "my-gitaction-cluster"
  
}

variable "ecs-service-name" {
default= "ecs-service-name-deploy"

  
}

variable "ecr-repo-name" {
default= "ecr-repo-nodejs-repo"
  
}

variable "container_port" {
  default = 3000
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "region" {
  default = "us-east-1"
}

variable "github_repo" {
  description = "GitHub repository name"
  default = "Awspipeline-Terraform-and-Gitaction-Automation"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for CodePipeline"
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub repository name"
  default = "rukevweubio"
}

variable "github_branch" {
default = "main"
  
}