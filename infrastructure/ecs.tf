# Create ECS Cluster
resource "aws_ecs_cluster" "fargate_cluster" {
  name = "alpeso-fargate-cluster"
}

# Create an IAM role for ECS tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Define ECS Task Definition
resource "aws_ecs_task_definition" "alpeso_task" {
  family                   = "alpeso-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256 # 0.25 vCPU
  memory                   = 512 # 512 MiB memory

  container_definitions = jsonencode([
    {
      name      = "alpeso-app",
      image     = "047719634602.dkr.ecr.eu-central-1.amazonaws.com/alpeso:98a9403cc9f6288b8718f1b5803c06bba9998caa",
      essential = true,
      portMappings = [
        {
          containerPort = 8089
          hostPort      = 8089
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Create Security Group for ECS Service
resource "aws_security_group" "fargate_sg" {
  name        = "fargate-sg"
  description = "Allow inbound traffic for app"
  vpc_id      = "vpc-080ae0cd7548d6b2d"

  # Allow inbound traffic to port 8089
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create ECS Fargate Service
resource "aws_ecs_service" "alpeso_fargate_service" {
  name            = "alpeso-fargate-service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.alpeso_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-08c08da8a0cb3e113", "subnet-09641e0cb2404b400"] # Update with your public subnets
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = true
  }
}

# Outputs to display ECS Cluster and Service information
output "ecs_cluster_name" {
  value = aws_ecs_cluster.fargate_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.alpeso_fargate_service.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.alpeso_task.arn
}
