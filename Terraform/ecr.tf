resource "aws_ecr_repository" "app" {
  name                 = var.app-name
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = var.app-name
  }
}