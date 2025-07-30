# --------------------------------------
# AWS Provider Configuration
# --------------------------------------
provider "aws" {
  region = "ap-south-1"
}

# --------------------------------------
# IAM Role for CodeBuild
# --------------------------------------
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

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

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:*",
          "s3:*",
          "iam:PassRole",
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
resource "aws_codebuild_project" "static_site_build" {
  name         = "static-site-build"
  description  = "Build project to sync static website files to S3"
  service_role = aws_iam_role.codebuild_role.arn

  # Source settings
  source {
    type      = "GITHUB"
    location  = "https://github.com/${var.github_owner}/${var.github_repo}.git"
    buildspec = "../buildspec.yml"
  }

  # Build environment
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  # Artifacts (we're not producing any output artifacts directly from CodeBuild)
  artifacts {
    type = "NO_ARTIFACTS"
  }
}

# --------------------------------------
# Secrets Manager: GitHub Token
# --------------------------------------
data "aws_secretsmanager_secret" "github_token" {
  name = "github/token"
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

# --------------------------------------
# CodePipeline
# --------------------------------------
resource "aws_codepipeline" "static_site_pipeline" {
  name     = "static-site-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = var.s3_bucket_name
  }

  # Source Stage (GitHub)
  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = data.aws_secretsmanager_secret_version.github_token.secret_string
      }
    }
  }

  # Build Stage (CodeBuild)
  stage {
    name = "Build"

    action {
      name             = "CodeBuild_Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.static_site_build.name
      }
    }
  }
}
