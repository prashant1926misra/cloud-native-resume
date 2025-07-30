# AWS Provider Configuration
provider "aws" {
  region = "ap-south-1" 
}

# --------------------------------------
# IAM Role for CodeBuild
# --------------------------------------

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


# --------------------------------------
# IAM Role for CodePipeline
# --------------------------------------

# This role allows CodePipeline to trigger CodeBuild and access AWS services
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy attached to the role: allows it to start CodeBuild & access S3
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "codebuild:*",
          "s3:*",
          "iam:PassRole"
		  "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

# --------------------------------------
# CodeBuild Project
# --------------------------------------

# Build and deploy the static website using buildspec.yml
resource "aws_codebuild_project" "static_site_build" {
  name         = "static-site-build"
  description  = "Build project to sync static website files to S3"
  
  service_role = aws_iam_role.codebuild_role.arn
}

  # -----------------------
  # Source code settings
  # -----------------------
  source {
    type      = "GITHUB"
    location  = "https://github.com/${var.github_owner}/${var.github_repo}.git"
    buildspec = "../buildspec.yml"
  }

  # -----------------------
  # Build environment
  # -----------------------
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0" # latest standard image
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  # -----------------------
  # Artifacts
  # -----------------------
  artifacts {
    type = "NO_ARTIFACTS" 
  }

# --------------------------------------
# Secrets Manager: GitHub token
# --------------------------------------

# Reference the secret we created manually (name: github/token)
data "aws_secretsmanager_secret" "github_token" {
  name = "github/token"
}

# Fetch the latest version of the secret
data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}
