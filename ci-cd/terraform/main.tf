# AWS Provider Configuration
provider "aws" {
  region = "ap-south-1" 
}

# ***********IAM Role for CodeBuild***********

# This role allows CodeBuild to access AWS resources
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  # Trust policy so CodeBuild can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy attached to the role: allows access to S3 & CloudWatch
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:*"]
        Resource = "*"
      }
    ]
  })
}
