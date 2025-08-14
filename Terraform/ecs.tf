# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.app-name}-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = var.app-name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = var.app-name
    image = "${aws_ecr_repository.app.repository_url}:latest"
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
  }])
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = var.app-name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public_subnet.id] # Replace with a list if multiple
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
