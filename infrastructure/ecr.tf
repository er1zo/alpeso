# Create an ECR repository
resource "aws_ecr_repository" "alpeso" {
  name                 = "alpeso"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "alpeso"
  }
}